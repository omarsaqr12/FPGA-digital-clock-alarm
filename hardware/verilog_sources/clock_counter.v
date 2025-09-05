`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Digital Clock with Alarm - FPGA Implementation  
// Module: Clock Counter
// Project: Digital Design Project 2
// Target Device: Basys 3 FPGA Board
// Authors: Adham Ali (adhamahmed804@aucegypt.edu)
//          Omar Saqr (omar_saqr@aucegypt.edu) 
//          Ebram Thabet (ebram_raafat@aucegypt.edu)
//          
// Description: Module for counting hours, minutes, and seconds with support 
//              for time adjustment. Handles cascading counters for proper timekeeping.
//////////////////////////////////////////////////////////////////////////////////

module Clock_Counter (
    input clk,                            
    input rst,                            
    input adjust_enable_minutes,         
    input adjust_enable_hours,           
    input enable_seconds,                
    input Up_down,                        
    output [3:0] hours_units,            
    output [3:0] minuites_units,         
    output [1:0] hours_tenth,            
    output [2:0] minutes_tenth,          
    output  [5:0] seconds_OUT        
);

    wire [5:0] minutes_OUT;              // Output wire for minutes counter
    wire [4:0] hours_OUT;                // Output wire for hours counter
    wire enable_hours, enable_minutes;   // Wires to control hours and minutes counter enables
    
    // Counter for seconds
    counter_x_bit #(6, 60) seconds_counter (
        .clk(clk),
        .reset(rst),
        .en(enable_seconds),
        .Up_down(Up_down),
        .count(seconds_OUT)
    );

    // Enable condition for minutes counter
    assign enable_minutes = enable_seconds ? (seconds_OUT == 6'd59) : adjust_enable_minutes;

    // Counter for minutes
    counter_x_bit #(6, 60) minutes_counter (
        .clk(clk),
        .reset(rst),
        .en(enable_minutes),
        .Up_down(Up_down),
        .count(minutes_OUT)
    );

    // Enable condition for hours counter
    assign enable_hours = enable_seconds ? ((seconds_OUT == 6'd59) && (minutes_OUT == 6'd59)) : adjust_enable_hours;

    // Counter for hours
    counter_x_bit #(5, 24) hours_counter (
        .clk(clk),
        .reset(rst),
        .en(enable_hours),
        .Up_down(Up_down),
        .count(hours_OUT)
    );

    // Outputs for tens and units of minutes
    assign minutes_tenth = minutes_OUT / 10;
    assign minuites_units = minutes_OUT % 10;

    // Outputs for tens and units of hours
    assign hours_tenth = hours_OUT / 10;
    assign hours_units = hours_OUT % 10;

endmodule
