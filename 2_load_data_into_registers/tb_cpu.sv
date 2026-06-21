`timescale 1ns/1ps

module tb_cpu;

    localparam logic [3:0] LOAD=1;

    logic clk = 0, reset = 1;
    logic [7:0] imem_addr, dmem_addr;
    logic [15:0] imem_rdata, dmem_rdata;

    cpu dut(.*);

    memory imem(clk, imem_addr, '0, 1'b0, imem_rdata);
    memory dmem(clk, dmem_addr, '0, 1'b0, dmem_rdata);

    initial forever #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_cpu);

        // Load memory location 0x2A into register 3.
        imem.mem[0]    = {LOAD, 4'h2, 4'hA, 4'h3};
        dmem.mem['h2A] = 16'hBEEF;

        @(posedge clk); #1ps reset = 0;
        @(posedge clk); #1ps;

        if (dut.regs[3] != 16'hBEEF) $fatal(1, "LOAD failed");
        $display("PASS: r3=%04h", dut.regs[3]);
        $finish;
    end

endmodule
