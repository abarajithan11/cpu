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

    typedef enum logic [3:0] {MOVE, LOAD, STORE, JNZ, ADD, SUB, MUL} op_t;
    typedef struct packed {op_t op; logic [3:0] src_1, src_2, dst;} instruction_t;

    logic [7:0] pc;
    logic [15:0] regs [0:15];
    logic [15:0] reg_1;
    instruction_t inst;

    always_comb begin
        imem_addr  = pc;
        inst       = instruction_t'(imem_rdata);
        reg_1      = regs[inst.src_1];
        dmem_addr  = inst.op == STORE ? {inst.src_2, inst.dst} : {inst.src_1, inst.src_2};
        dmem_wdata = reg_1;
        dmem_we    = !reset && inst.op == STORE;
    end

    always_ff @(posedge clk) begin
        if (reset) begin
            pc <= '0;
            for (int i = 0; i < 16; i++) regs[i] <= '0;
        end else begin
            pc <= pc + 1'b1;
            case (inst.op) // New!
                MOVE: regs[inst.dst] <= reg_1; // New!
                LOAD: regs[inst.dst] <= dmem_rdata;
                default: ; // New!
            endcase // New!
        end
    end

endmodule
