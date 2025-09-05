`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Digital Clock with Alarm - FPGA Implementation
// Module: Synchronizer
// Project: Digital Design Project 2
// Target Device: Basys 3 FPGA Board
// Authors: Adham Ali (adhamahmed804@aucegypt.edu)
//          Omar Saqr (omar_saqr@aucegypt.edu) 
//          Ebram Thabet (ebram_raafat@aucegypt.edu)
//          
// Description: Module for synchronizing an input signal to the clock domain.
//              Uses 2 flip-flops to prevent metastability issues.
//////////////////////////////////////////////////////////////////////////////////

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
