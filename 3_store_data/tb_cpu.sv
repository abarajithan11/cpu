`timescale 1ns/1ps

module tb_cpu;
  typedef enum logic [3:0] {LOAD, STORE} op_t;

  logic clk = 0, reset = 1;
  logic [7:0] imem_addr, dmem_addr;
  logic [15:0] imem_rdata, dmem_rdata, dmem_wdata;
  logic dmem_wen;

  cpu dut(.*);

  memory imem(clk, imem_addr,         '0,     1'b0, imem_rdata);
  memory dmem(clk, dmem_addr, dmem_wdata, dmem_wen, dmem_rdata);

  initial forever #5 clk = ~clk;

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, tb_cpu);

    dmem.mem['h2A] = 16'hBEEF;

    // Load 0xBEEF into r3, then store r3 at address 0x40.
    imem.mem[0]    = {8'h2A,        4'h3, LOAD};  // r3 = mem[0x2A]
    imem.mem[1]    = {8'h40,        4'h3, STORE}; // mem[0x40] = r3

    @(posedge clk); #1ps reset = 0;
    repeat (2) @(posedge clk);
    #1ps;

    if (dmem.mem['h40] != 16'hBEEF) $fatal(1, "STORE failed");
    $display("PASS: mem[40]=%04h", dmem.mem['h40]);
    $finish;
  end

endmodule
