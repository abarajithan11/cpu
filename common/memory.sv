`timescale 1ns/1ps

module memory (
  input  logic        clk,
  input  logic [7:0]  addr,
  input  logic [15:0] wdata,
  input  logic        we,
  output logic [15:0] rdata
);
  logic [15:0] mem [0:255];

  always_ff @(posedge clk)
    if (we) mem[addr] <= wdata;

  always_comb rdata = mem[addr];

endmodule
