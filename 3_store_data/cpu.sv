`timescale 1ns/1ps

module cpu (
  input  logic        clk,
  input  logic        reset,

  output logic [7:0]  imem_addr,
  input  logic [15:0] imem_rdata,

  output logic [7:0]  dmem_addr,
  input  logic [15:0] dmem_rdata,
  output logic [15:0] dmem_wdata, // --- new
  output logic        dmem_wen    // --- new
);
  import cpu_types::*;
  instruction_t inst;
  logic [7:0] pc;
  logic [15:0] regs [0:15];
  logic [15:0] reg_1; // --- new

  always_comb begin
    imem_addr  = pc;
    inst       = instruction_t'(imem_rdata);

    dmem_addr  = inst.a.addr;
    dmem_wdata = regs[inst.a.rid]; // --- new
    dmem_wen   = !reset && inst.a.op == STORE; // --- new
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      pc   <= '0;
      regs <= '{default: '0};
    end else begin
      pc   <= pc + 1'b1;

      case (inst.r.op)
        LOAD: regs[inst.a.rid] <= dmem_rdata;
        default: ;
      endcase
    end
  end

endmodule
