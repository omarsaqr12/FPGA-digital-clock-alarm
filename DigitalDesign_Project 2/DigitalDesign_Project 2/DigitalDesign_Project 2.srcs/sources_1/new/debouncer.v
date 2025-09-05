`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29/4/2024 06:50:52 PM
// Design Name: 
// Module Name: Debouncer
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
* Module: Debouncer.v
* Project: Digital Design (Project 2)

* Author: Adham Ali/ adhamahmed804@aucegypt.edu 
          Omar Saqr/ omar_saqr@aucegypt.edu 
          Ebram Thabet / ebram_raafat@aucegypt.edu 
          
*Description: Module for debouncing an input signal using sequential logic  
************************/

module debouncer(
    input clk,     
    input rst,     
    input in,      
    output out    
);
    reg q1, q2, q3;  
    
    // Sequential logic for debouncing input signal
    always @(posedge clk, posedge rst) begin
        if (rst == 1'b1) begin
            // Reset registers to 0 during reset
            q1 <= 0;
            q2 <= 0;
            q3 <= 0;
        end
        else begin
            // Shift input signal through registers
            q1 <= in;
            q2 <= q1;
            q3 <= q2;
        end
    end
    
    // Output is debounced output signal, reset to 0 during reset
    assign out = (rst) ? 0 : (q1 & q2 & q3);

endmodule
