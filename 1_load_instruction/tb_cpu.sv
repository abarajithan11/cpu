`timescale 1ns/1ps

module tb_cpu;
    import cpu_types::*;

    logic clk = 0, reset = 1;
    logic [7:0] imem_addr;
    logic [15:0] imem_rdata;

    cpu dut(.*);

    memory imem(clk, imem_addr, '0, 1'b0, imem_rdata);

    initial forever #5 clk = ~clk;

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_cpu);

        // Read and display three example instructions.
        imem.mem[0] = {8'h2A,        4'h3, LOAD};  // r3 = mem[0x2A]
        imem.mem[1] = {4'h0,  4'h3,  4'h4, MOVE};  // r4 = r3
        imem.mem[2] = {8'h40,        4'h4, STORE}; // mem[0x40] = r4

        @(posedge clk); #1ps reset = 0;
        repeat (3) @(posedge clk);
        #1ps;

        if (imem_addr != 8'd3) $fatal(1, "Instruction fetch failed");
        $display("PASS: fetched three instructions");
        $finish;
    end

endmodule
