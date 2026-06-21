`timescale 1ns/1ps

module tb_cpu;

    localparam logic [3:0] LOAD=1, STORE=2;

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

        // Load 0xBEEF into r3, then store r3 at address 0x40.
        imem.mem[0]    = {LOAD,  4'h2, 4'hA, 4'h3};
        imem.mem[1]    = {STORE, 4'h3, 4'h4, 4'h0};
        dmem.mem['h2A] = 16'hBEEF;

        @(posedge clk); #1ps reset = 0;
        repeat (2) @(posedge clk);
        #1ps;

        if (dmem.mem['h40] != 16'hBEEF) $fatal(1, "STORE failed");
        $display("PASS: mem[40]=%04h", dmem.mem['h40]);
        $finish;
    end

endmodule
