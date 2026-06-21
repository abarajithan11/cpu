`timescale 1ns/1ps

module tb_cpu;

    localparam logic [3:0] LOAD=1, ADD=4, SUB=5, MUL=6;

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

        // Load 7 and 3, then calculate their sum, difference, and product.
        imem.mem[0] = {LOAD, 4'h1, 4'h0, 4'h1};
        imem.mem[1] = {LOAD, 4'h1, 4'h1, 4'h2};
        imem.mem[2] = {ADD,  4'h1, 4'h2, 4'h3};
        imem.mem[3] = {SUB,  4'h1, 4'h2, 4'h4};
        imem.mem[4] = {MUL,  4'h1, 4'h2, 4'h5};

        dmem.mem['h10] = 16'd7;
        dmem.mem['h11] = 16'd3;

        @(posedge clk); #1ps reset = 0;
        repeat (5) @(posedge clk);
        #1ps;

        if (dut.regs[3] != 10) $fatal(1, "ADD failed");
        if (dut.regs[4] != 4)  $fatal(1, "SUB failed");
        if (dut.regs[5] != 21) $fatal(1, "MUL failed");

        $display("PASS: add=%0d sub=%0d mul=%0d",
                 dut.regs[3], dut.regs[4], dut.regs[5]);
        $finish;
    end

endmodule
