`timescale 1ns/1ps

module cpu (
  input  logic        clk,
  input  logic        reset,

  output logic [7:0]  imem_addr,
  input  logic [15:0] imem_rdata,

  output logic [7:0]  dmem_addr,  // --- new
  input  logic [15:0] dmem_rdata // --- new
);
  import cpu_types::*;
  instruction_t inst;
  logic [7:0] pc;
  logic [15:0] regs [0:15]; // --- new

  always_comb begin
    imem_addr  = pc;
    inst       = instruction_t'(imem_rdata);

    dmem_addr  = inst.a.addr; // --- new
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      pc   <= '0;
      regs <= '{default: '0}; // --- new
    end else begin
      pc   <= pc + 1'b1;

      case (inst.r.op) // --- new
        LOAD: regs[inst.a.rid] <= dmem_rdata; // --- new
        default: ;
      endcase
    end
  end

endmodule
