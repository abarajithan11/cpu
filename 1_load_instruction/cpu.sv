`timescale 1ns/1ps

module cpu (
    input  logic        clk,
    input  logic        reset,
    output logic [7:0]  imem_addr,
    input  logic [15:0] imem_rdata
);
    import cpu_types::*;

    logic [7:0] pc;
    instruction_t inst;

    always_comb begin
        imem_addr = pc;
        inst = instruction_t'(imem_rdata);
    end

    always_ff @(posedge clk) begin
        if (reset) pc <= '0;
        else       pc <= pc + 1'b1;
    end

endmodule
