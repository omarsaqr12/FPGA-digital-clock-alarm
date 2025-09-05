`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Digital Clock with Alarm - FPGA Implementation
// Module: Finite State Machine
// Project: Digital Design Project 2
// Target Device: Basys 3 FPGA Board
// Authors: Adham Ali (adhamahmed804@aucegypt.edu)
//          Omar Saqr (omar_saqr@aucegypt.edu) 
//          Ebram Thabet (ebram_raafat@aucegypt.edu)
//          
// Description: Finite State Machine (FSM) for state transition based on input signal 'w'.
//              Used in button detection to generate single pulse output.
//////////////////////////////////////////////////////////////////////////////////

module fsm(
    input clk, 
    rst, w, 
    output z
);
    
    reg [1:0] state, nextState;
    parameter [1:0] A=2'b00, B=2'b01, C=2'b10; // States Encoding
    // Next state generation (combinational logic)
    always @ (w or state)
    case (state)
    A: if (w==0) nextState = A;
    else nextState = B;
    B: if (w==0) nextState = A;
    else nextState = C;
    C: if (w==0) nextState = A;
    else nextState = C;
    default: nextState = A;
    endcase
    // State register
    // Update state FF's with the triggering edge of the clock
    always @ (posedge clk or posedge rst) begin
    if(rst) state <= A;
    else state <= nextState;
    end
    // output generation (combinational logic)
    assign z = (rst ==0 && state == B);
endmodule
