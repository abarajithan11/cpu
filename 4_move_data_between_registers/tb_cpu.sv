`timescale 1ns/1ps

module tb_cpu;

    localparam logic [3:0] MOVE=0, LOAD=1;

    logic clk = 0, reset = 1;
    logic [7:0] imem_addr, dmem_addr;
    logic [15:0] imem_rdata, dmem_rdata, dmem_wdata;
    logic dmem_we;

    cpu dut(.*);

    memory imem(clk, imem_addr, '0,         1'b0,    imem_rdata);
    memory dmem(clk, dmem_addr, dmem_wdata, dmem_we, dmem_rdata);

    initial forever #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_cpu);

        // Load 0x1234 into r1, then copy r1 into r2.
        imem.mem[0]    = {LOAD, 4'h2, 4'hA, 4'h1};
        imem.mem[1]    = {MOVE, 4'h1, 4'h0, 4'h2};
        dmem.mem['h2A] = 16'h1234;

        @(posedge clk); #1ps reset = 0;
        repeat (2) @(posedge clk);
        #1ps;

        if (dut.regs[2] != 16'h1234) $fatal(1, "MOVE failed");
        $display("PASS: r2=%04h", dut.regs[2]);
        $finish;
    end

endmodule
