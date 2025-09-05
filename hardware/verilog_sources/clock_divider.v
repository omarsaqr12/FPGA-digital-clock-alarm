`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Digital Clock with Alarm - FPGA Implementation
// Module: Clock Divider
// Project: Digital Design Project 2  
// Target Device: Basys 3 FPGA Board
// Authors: Adham Ali (adhamahmed804@aucegypt.edu)
//          Omar Saqr (omar_saqr@aucegypt.edu) 
//          Ebram Thabet (ebram_raafat@aucegypt.edu)
//          
// Description: Clock divider module that generates an output clock signal 
//              with a frequency divided by parameter 'n'. Used to create
//              1Hz and 200Hz clocks from the 100MHz system clock.
//////////////////////////////////////////////////////////////////////////////////

module clockDivider #(parameter n = 50000000)(
    input clk, 
    rst, 
    output reg clk_out
);
    wire [31:0] count;
    // Big enough to hold the maximum possible value
    // Increment count
    counter_x_bit #(32,n) counterMod(.clk(clk), .reset(rst),.en(1'b1), .Up_down (1'b1),.count(count));
    // Handle the output clock
    always @ (posedge clk, posedge rst) begin
    if (rst) // Asynchronous Reset
    clk_out <= 0;
    else if (count == n-1)
    clk_out <= ~ clk_out;
    end
endmodule
