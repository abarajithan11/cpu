`timescale 1ns/1ps

module cpu (
  input  logic        clk,
  input  logic        reset,

  output logic [7:0]  imem_addr,
  input  logic [15:0] imem_rdata,

  output logic [7:0]  dmem_addr,
  input  logic [15:0] dmem_rdata,
  output logic [15:0] dmem_wdata,
  output logic        dmem_wen
);
  import cpu_types::*;
  instruction_t inst;
  logic [7:0] pc;
  logic [15:0] regs [0:15];
  logic [15:0] reg_1, reg_2;

  always_comb begin
    imem_addr  = pc;
    inst       = instruction_t'(imem_rdata);

    dmem_addr  = inst.a.addr;
    dmem_wdata = regs[inst.a.rid];
    dmem_wen   = !reset && inst.a.op == STORE;

    reg_1      = regs[inst.r.src_1];
    reg_2      = regs[inst.r.src_2];
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      pc   <= '0;
      regs <= '{default: '0};
    end else begin
      pc   <= pc + 1'b1;

      case (inst.r.op)
        LOAD: regs[inst.a.rid] <= dmem_rdata;
        MOVE: regs[inst.r.dst] <= reg_1;
        ADD : regs[inst.r.dst] <= reg_1 + reg_2;
        SUB : regs[inst.r.dst] <= reg_1 - reg_2;
        MUL : regs[inst.r.dst] <= reg_1 * reg_2;
        JNZ : if (regs[inst.a.rid] != '0) pc <= inst.a.addr; // --- new
        default: ;
      endcase
    end
  end

endmodule
