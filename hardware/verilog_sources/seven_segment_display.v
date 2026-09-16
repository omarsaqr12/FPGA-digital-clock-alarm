`timescale 1ns / 1ps
// Seven-segment decoder and active-low digit selection for the Basys 3.
// Original collaborative project: Adham Ali, Omar Saqr, Ebram Thabet.
module seven_segment_display(
    input [3:0] inp1, inp2, inp3, inp4,
    input [1:0] enable,
    output reg [3:0] anode_active,
    output reg [6:0] segments
);
    reg [3:0] num;

    // @* includes all four data inputs. The earlier (num, enable) sensitivity
    // list could leave simulated segments stale when a selected input changed.
    always @* begin
        anode_active = 4'b1111;
        num = 4'hf;
        case (enable)
            2'b00: begin anode_active = 4'b0111; num = inp1; end
            2'b01: begin anode_active = 4'b1011; num = inp2; end
            2'b10: begin anode_active = 4'b1101; num = inp3; end
            2'b11: begin anode_active = 4'b1110; num = inp4; end
            default: begin anode_active = 4'b1111; num = 4'hf; end
        endcase

        case (num)
            4'd0: segments = 7'b0000001;
            4'd1: segments = 7'b1001111;
            4'd2: segments = 7'b0010010;
            4'd3: segments = 7'b0000110;
            4'd4: segments = 7'b1001100;
            4'd5: segments = 7'b0100100;
            4'd6: segments = 7'b0100000;
            4'd7: segments = 7'b0001111;
            4'd8: segments = 7'b0000000;
            4'd9: segments = 7'b0000100;
            default: segments = 7'b1111111;
        endcase
    end
endmodule
