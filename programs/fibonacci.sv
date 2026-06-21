`timescale 1ns/1ps

module fibonacci;
    import cpu_types::*;

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
        $dumpvars(0, fibonacci);

        dmem.mem[0] = 16'd10;
        dmem.mem[1] = 16'd1;
        dmem.mem[2] = 16'd0;

        // Initialize counter, constant one, and consecutive Fibonacci values.
        imem.mem[0] = {8'h00,        4'h1, LOAD};  // r1 (counter) = 10
        imem.mem[1] = {8'h01,        4'h2, LOAD};  // r2 (one) = 1
        imem.mem[2] = {8'h02,        4'h3, LOAD};  // r3 (a) = 0
        imem.mem[3] = {8'h01,        4'h4, LOAD};  // r4 (b) = 1

        // Advance the pair and repeat ten times.
        imem.mem[4] = {4'h4,  4'h3,  4'h5, ADD};   // r5 (next) = r3 (a) + r4 (b)
        imem.mem[5] = {4'h0,  4'h4,  4'h3, MOVE};  // r3 (a) = r4 (b)
        imem.mem[6] = {4'h0,  4'h5,  4'h4, MOVE};  // r4 (b) = r5 (next)
        imem.mem[7] = {4'h2,  4'h1,  4'h1, SUB};   // r1 (counter) -= r2 (one)
        imem.mem[8] = {8'h04,        4'h1, JNZ};   // repeat while r1 (counter) != 0

        imem.mem[9] = {8'h10,        4'h3, STORE}; // mem[0x10] = r3 = F(10)

        @(posedge clk); #1ps reset = 0;
        repeat (56) @(posedge clk);
        #1ps;

        if (dmem.mem['h10] != 55) $fatal(1, "Fibonacci failed");

        $display("PASS: fibonacci(10)=%0d", dmem.mem['h10]);
        $finish;
    end

endmodule
