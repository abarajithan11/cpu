`timescale 1ns/1ps

module tb_cpu;

    localparam logic [3:0] LOAD=1, JNZ=3;

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

        // Put 1 in r1 and address 4 in r2, then jump from PC 2 to PC 4.
        imem.mem[0] = {LOAD, 4'h1, 4'h0, 4'h1};
        imem.mem[1] = {LOAD, 4'h1, 4'h1, 4'h2};
        imem.mem[2] = {JNZ,  4'h1, 4'h2, 4'h0};
        imem.mem[3] = {LOAD, 4'h1, 4'h2, 4'h3}; // Skipped.
        imem.mem[4] = {LOAD, 4'h1, 4'h3, 4'h3};

        dmem.mem['h10] = 16'd1;
        dmem.mem['h11] = 16'd4;
        dmem.mem['h12] = 16'hDEAD;
        dmem.mem['h13] = 16'hBEEF;

        @(posedge clk); #1ps reset = 0;
        repeat (4) @(posedge clk);
        #1ps;

        if (dut.regs[3] != 16'hBEEF) $fatal(1, "JNZ failed");
        $display("PASS: r3=%04h", dut.regs[3]);
        $finish;
    end

endmodule
