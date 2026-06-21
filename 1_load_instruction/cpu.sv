`timescale 1ns/1ps

module cpu (
    input  logic        clk,
    input  logic        reset,
    output logic [7:0]  imem_addr,
    input  logic [15:0] imem_rdata
);
    logic [7:0] pc;

    always_comb imem_addr = pc;

    always_ff @(posedge clk) begin
        if (reset) pc <= '0;
        else       pc <= pc + 1'b1;
    end

endmodule
