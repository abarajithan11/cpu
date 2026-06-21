`timescale 1ns/1ps

module tb_cpu;

    localparam logic [3:0] MOVE=0, LOAD=1, STORE=2;

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
        imem.mem[0] = {LOAD,  4'h2, 4'hA, 4'h3};
        imem.mem[1] = {MOVE,  4'h3, 4'h0, 4'h4};
        imem.mem[2] = {STORE, 4'h4, 4'h4, 4'h0};

        @(posedge clk); #1ps reset = 0;
        repeat (3) @(posedge clk);
        #1ps;

        if (imem_addr != 8'd3) $fatal(1, "Instruction fetch failed");
        $display("PASS: fetched three instructions");
        $finish;
    end

endmodule
