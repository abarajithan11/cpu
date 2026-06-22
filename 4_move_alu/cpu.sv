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
  logic [7:0] pc, addr;
  typedef enum logic [3:0] {LOAD, STORE, MOVE, ADD, SUB, MUL} op_t;
  logic [3:0] op, i_rs1, i_rs2, i_rd, i_reg;
  logic [15:0] regs [0:15];
  logic [15:0] reg_1, reg_2; // --- new

  always_comb begin
    imem_addr                 = pc;
    {addr        , i_reg, op} = imem_rdata;
    {i_rs2, i_rs1, i_rd , op} = imem_rdata;  // --- new

    dmem_addr  = addr;
    dmem_wdata = regs[i_reg];
    dmem_wen   = !reset && op == STORE;

    reg_1      = regs[i_rs1]; // --- new
    reg_2      = regs[i_rs2]; // --- new
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      pc   <= '0;
      regs <= '{default: '0};
    end else begin
      pc   <= pc + 1'b1;

      case (op)
        LOAD: regs[i_reg] <= dmem_rdata;
        MOVE: regs[i_rd ] <= reg_1;         // --- new
        ADD : regs[i_rd ] <= reg_1 + reg_2; // --- new
        SUB : regs[i_rd ] <= reg_1 - reg_2; // --- new
        MUL : regs[i_rd ] <= reg_1 * reg_2; // --- new
        default: ;
      endcase
    end
  end

endmodule
