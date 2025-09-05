`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 8/5/2024 06:52:03 PM
// Design Name: 
// Module Name: synchronizer
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
* Module: synchronizer.v
* Project: Digital Design (Project 2)

* Author: Adham Ali/ adhamahmed804@aucegypt.edu 
          Omar Saqr/ omar_saqr@aucegypt.edu 
          Ebram Thabet / ebram_raafat@aucegypt.edu 
          
 *Description: Module for synchronizing an input signal to the clock domain
       
************************/

module synchronizer(
    input clk,      
    input rst,      
    input in,      
    output out      
);

    reg q1, q2;     // Registers for synchronizing input signal
    
    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1) begin
            q1 <= 0;  
            q2 <= 0; 
        end
        else begin
            q1 <= in;  
            q2 <= q1;  
        end
    end
    
    // Output is synchronized output signal, reset to 0 during reset
    assign out = (rst) ? 0 : q2;

endmodule