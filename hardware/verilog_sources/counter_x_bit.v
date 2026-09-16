`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Digital Clock with Alarm - FPGA Implementation
// Module: Generic Counter
// Project: Digital Design Project 2
// Target Device: Basys 3 FPGA Board
// Authors: Adham Ali (adhamahmed804@aucegypt.edu)
//          Omar Saqr (omar_saqr@aucegypt.edu)
//          Ebram Thabet (ebram_raafat@aucegypt.edu)
//
// Configurable modulo-n up/down counter with enable and asynchronous reset.
//////////////////////////////////////////////////////////////////////////////////
module counter_x_bit #(parameter x = 3, n = 6)(
    input clk,
    input reset,
    input en,
    input Up_down,
    output reg [x-1:0] count
);
    // The port itself is a register. A separate `reg count` declaration here
    // previously redeclared an output wire and prevented Icarus elaboration.
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
        end else if (en) begin
            if (Up_down) begin
                if (count == n - 1)
                    count <= 0;
                else
                    count <= count + 1'b1;
            end else begin
                if (count == 0)
                    count <= n - 1;
                else
                    count <= count - 1'b1;
            end
        end
    end
endmodule
