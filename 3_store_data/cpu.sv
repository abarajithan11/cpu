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
  logic [7:0] pc;
  typedef enum logic [3:0] {LOAD, STORE} op_t;
  logic [3:0] op, src_1, src_2, dst, rid;
  logic [7:0] addr;
  logic [15:0] regs [0:15];

  always_comb begin
    imem_addr               = pc;
    {addr        , rid, op} = imem_rdata;
    {src_2, src_1, dst, op} = imem_rdata; // --- new

    dmem_addr  = addr;
    dmem_wdata = regs[rid]; // --- new
    dmem_wen   = !reset && op == STORE; // --- new
  end

  always_ff @(posedge clk) begin
    if (reset) begin
      pc   <= '0;
      regs <= '{default: '0};
    end else begin
      pc   <= pc + 1'b1;

      case (op)
        LOAD: regs[rid] <= dmem_rdata;
        default: ;
      endcase
    end
  end

endmodule
