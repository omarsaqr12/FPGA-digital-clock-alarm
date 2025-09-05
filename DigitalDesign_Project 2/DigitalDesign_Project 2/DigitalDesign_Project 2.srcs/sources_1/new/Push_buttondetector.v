`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24/4/2024 07:12:59 PM
// Design Name: 
// Module Name: SMASH_buttondetector
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

/***********************
*
* Module: Push_buttondetector.v
* Project: Digital Design (Project 2)

* Author: Adham Ali/ adhamahmed804@aucegypt.edu 
          Omar Saqr/ omar_saqr@aucegypt.edu 
          Ebram Thabet / ebram_raafat@aucegypt.edu 
          
*Description:  Module for detecting and debouncing a push button signal using sequential logic             
************************/

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