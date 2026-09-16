`timescale 1ns / 1ps
module tb_counter_x_bit;
    reg clk = 0, reset = 0, en = 0, Up_down = 1;
    wire [2:0] count;
    counter_x_bit #(3, 6) dut(.clk(clk), .reset(reset), .en(en), .Up_down(Up_down), .count(count));
    always #5 clk = ~clk;
    task tick;
        begin @(posedge clk); #1; end
    endtask
    initial begin
        reset = 1; #2;
        if (count !== 0) $fatal(1, "asynchronous reset failed");
        reset = 0;
        en = 1;
        repeat (5) tick();
        if (count !== 5) $fatal(1, "increment to 5 failed: %d", count);
        tick();
        if (count !== 0) $fatal(1, "modulo-6 wrap failed: %d", count);
        Up_down = 0;
        tick();
        if (count !== 5) $fatal(1, "decrement underflow failed: %d", count);
        en = 0;
        tick();
        if (count !== 5) $fatal(1, "disabled counter advanced");
        $display("PASS tb_counter_x_bit");
        $finish;
    end
endmodule
