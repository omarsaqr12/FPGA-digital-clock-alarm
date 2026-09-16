`timescale 1ns / 1ps
module tb_seven_segment_display;
    reg [3:0] inp1, inp2, inp3, inp4;
    reg [1:0] enable;
    wire [3:0] anode_active;
    wire [6:0] segments;
    seven_segment_display dut(
        .inp1(inp1), .inp2(inp2), .inp3(inp3), .inp4(inp4),
        .enable(enable), .anode_active(anode_active), .segments(segments)
    );
    initial begin
        inp1 = 0; inp2 = 2; inp3 = 3; inp4 = 4; enable = 0;
        #2;
        if (anode_active !== 4'b0111 || segments !== 7'b0000001)
            $fatal(1, "digit 1 zero decode failed");
        // Regression: selected input changes while enable stays constant.
        inp1 = 1; #2;
        if (anode_active !== 4'b0111 || segments !== 7'b1001111)
            $fatal(1, "selected input change not reflected");
        enable = 1; #2;
        if (anode_active !== 4'b1011 || segments !== 7'b0010010)
            $fatal(1, "digit 2 decode failed");
        inp2 = 4'hf; #2;
        if (segments !== 7'b1111111)
            $fatal(1, "invalid BCD must blank segments");
        enable = 2; #2;
        if (anode_active !== 4'b1101 || segments !== 7'b0000110)
            $fatal(1, "digit 3 decode failed");
        enable = 3; #2;
        if (anode_active !== 4'b1110 || segments !== 7'b1001100)
            $fatal(1, "digit 4 decode failed");
        $display("PASS tb_seven_segment_display");
        $finish;
    end
endmodule
