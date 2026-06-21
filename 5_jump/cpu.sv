`timescale 1ns/1ps

module cpu (
    input  logic        clk,
    input  logic        reset,

    output logic [7:0]  imem_addr,
    input  logic [15:0] imem_rdata,

    output logic [7:0]  dmem_addr,
    output logic [15:0] dmem_wdata,
    output logic        dmem_we,
    input  logic [15:0] dmem_rdata
);
    import cpu_types::*;

    logic [7:0] pc;
    logic [15:0] regs [0:15];
    logic [15:0] reg_1, reg_2;
    instruction_t inst;

    always_comb begin
        imem_addr  = pc;
        inst       = instruction_t'(imem_rdata);
        reg_1      = regs[inst.rtype.src_1];
        reg_2      = regs[inst.rtype.src_2];
        dmem_addr  = inst.atype.addr;
        dmem_wdata = regs[inst.atype.reg_idx];
        dmem_we    = !reset && inst.atype.op == STORE;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= '0;
            for (int i = 0; i < 16; i++) regs[i] <= '0;
        end else begin
            pc <= inst.atype.op == JNZ && regs[inst.atype.reg_idx] != '0
                ? inst.atype.addr : pc + 1'b1; // New!
            case (inst.rtype.op)
                MOVE: regs[inst.rtype.dst] <= reg_1;
                LOAD: regs[inst.atype.reg_idx] <= dmem_rdata;
                ADD:  regs[inst.rtype.dst] <= reg_1 + reg_2;
                SUB:  regs[inst.rtype.dst] <= reg_1 - reg_2;
                MUL:  regs[inst.rtype.dst] <= reg_1 * reg_2;
                default: ;
            endcase
        end
    end

endmodule
