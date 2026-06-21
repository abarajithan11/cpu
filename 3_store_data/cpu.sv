`timescale 1ns/1ps

module cpu (
    input  logic        clk,
    input  logic        reset,

    output logic [7:0]  imem_addr,
    input  logic [15:0] imem_rdata,

    output logic [7:0]  dmem_addr,
    output logic [15:0] dmem_wdata, // New!
    output logic        dmem_we, // New!
    input  logic [15:0] dmem_rdata
);
    import cpu_types::*;

    logic [7:0] pc;
    logic [15:0] regs [0:15];
    logic [15:0] reg_1; // New!
    instruction_t inst;

    always_comb begin
        imem_addr  = pc;
        inst       = instruction_t'(imem_rdata);
        reg_1      = regs[inst.atype.reg_idx]; // New!
        dmem_addr  = inst.atype.addr; // New!
        dmem_wdata = reg_1; // New!
        dmem_we    = !reset && inst.atype.op == STORE; // New!
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= '0;
            for (int i = 0; i < 16; i++) regs[i] <= '0;
        end else begin
            pc <= pc + 1'b1;
            if (inst.atype.op == LOAD) regs[inst.atype.reg_idx] <= dmem_rdata;
        end
    end

endmodule
