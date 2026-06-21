`timescale 1ns/1ps

module cpu (
    input  logic        clk,
    input  logic        reset,

    output logic [7:0]  imem_addr,
    input  logic [15:0] imem_rdata,

    output logic [7:0]  dmem_addr,
    input  logic [15:0] dmem_rdata
);

    typedef enum logic [3:0] {MOVE, LOAD, STORE, JNZ, ADD, SUB, MUL} op_t; // New!
    typedef struct packed {op_t op; logic [3:0] src_1, src_2, dst;} instruction_t; // New!

    logic [7:0] pc;
    logic [15:0] regs [0:15]; // New!
    instruction_t inst; // New!

    always_comb begin
        imem_addr = pc;
        inst      = instruction_t'(imem_rdata); // New!
        dmem_addr = {inst.src_1, inst.src_2}; // New!
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= '0;
            for (int i = 0; i < 16; i++) regs[i] <= '0; // New!
        end else begin
            pc <= pc + 1'b1;
            if (inst.op == LOAD) regs[inst.dst] <= dmem_rdata; // New!
        end
    end

endmodule
