`timescale 1ns/1ps

module cpu (
  input  logic        clk,
  input  logic        reset,

  output logic [7:0]  imem_addr,
  input  logic [15:0] imem_rdata,

  output logic [7:0]  dmem_addr,  // --- new
  input  logic [15:0] dmem_rdata // --- new
);
  logic [7:0] pc;
  typedef enum logic [3:0] {LOAD} op_t; // --- new
  logic [3:0] op, rid; // --- new
  logic [7:0] addr; // --- new
  logic [15:0] regs [0:15]; // --- new

  always_comb begin
    imem_addr       = pc;
    {addr, rid, op} = imem_rdata; // --- new

    dmem_addr = addr; // --- new
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      pc   <= '0;
      regs <= '{default: '0}; // --- new
    end else begin
      pc   <= pc + 1'b1;

      case (op) // --- new
        LOAD: regs[rid] <= dmem_rdata; // --- new
        default: ;
      endcase
    end
  end

endmodule
