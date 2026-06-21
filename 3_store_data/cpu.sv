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

    typedef enum logic [3:0] {MOVE, LOAD, STORE, JNZ, ADD, SUB, MUL} op_t;
    typedef struct packed {op_t op; logic [3:0] src_1, src_2, dst;} instruction_t;

    logic [7:0] pc;
    logic [15:0] regs [0:15];
    logic [15:0] reg_1; // New!
    instruction_t inst;

    always_comb begin
        imem_addr  = pc;
        inst       = instruction_t'(imem_rdata);
        reg_1      = regs[inst.src_1]; // New!
        dmem_addr  = inst.op == STORE ? {inst.src_2, inst.dst} : {inst.src_1, inst.src_2}; // New!
        dmem_wdata = reg_1; // New!
        dmem_we    = !reset && inst.op == STORE; // New!
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= '0;
            for (int i = 0; i < 16; i++) regs[i] <= '0;
        end else begin
            pc <= pc + 1'b1;
            if (inst.op == LOAD) regs[inst.dst] <= dmem_rdata;
        end
    end

endmodule
