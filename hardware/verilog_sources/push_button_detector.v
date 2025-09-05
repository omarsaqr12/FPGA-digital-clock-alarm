`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Digital Clock with Alarm - FPGA Implementation
// Module: Push Button Detector
// Project: Digital Design Project 2
// Target Device: Basys 3 FPGA Board
// Authors: Adham Ali (adhamahmed804@aucegypt.edu)
//          Omar Saqr (omar_saqr@aucegypt.edu) 
//          Ebram Thabet (ebram_raafat@aucegypt.edu)
//          
// Description: Module for detecting and debouncing a push button signal using
//              sequential logic. Combines debouncer, synchronizer, and FSM for
//              reliable button press detection.
//////////////////////////////////////////////////////////////////////////////////

module Push_buttondetector(
    input clk_in,
     rst,
     in, 
     output out
 );
  
    wire out_1, out_2; 
    
    debouncer DB (.clk(clk_in), .rst(rst), .in(in), .out(out_1));
    synchronizer SYN (.clk(clk_in), .rst(rst), .in(out_1), .out(out_2));
    fsm machine(.clk(clk_in), .rst(rst), .w(out_2), .z(out));
   
endmodule
