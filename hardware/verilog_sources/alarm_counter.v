`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Digital Clock with Alarm - FPGA Implementation
// Module: Alarm Counter
// Project: Digital Design Project 2
// Target Device: Basys 3 FPGA Board
// Authors: Adham Ali (adhamahmed804@aucegypt.edu)
//          Omar Saqr (omar_saqr@aucegypt.edu) 
//          Ebram Thabet (ebram_raafat@aucegypt.edu)
//          
// Description: Module for counting minutes and hours for alarm functionality
//              Allows adjustment of alarm time using up/down controls
//////////////////////////////////////////////////////////////////////////////////

module Alarm_Counter (
    input clk,                             
    input rst,                              
    input adjust_enable_minutes,            
    input adjust_enable_hours,             
    input Up_down,                          
    output  [3:0] hours_units,           
    output  [3:0] minutes_units,       
    output  [1:0] hours_tenth,          
    output  [2:0] minutes_tenth         
);

    wire [5:0] minutes_OUT;                
    wire [4:0] hours_OUT;                  

    // Counter for minutes
    counter_x_bit #(6, 60) minutes_counter (
        .clk(clk),
        .reset(rst),
        .en(adjust_enable_minutes),
        .Up_down(Up_down),
        .count(minutes_OUT)
    );

    // Counter for hours
    counter_x_bit #(5, 24) hours_counter (
        .clk(clk),
        .reset(rst),
        .en(adjust_enable_hours),
        .Up_down(Up_down),
        .count(hours_OUT)
    );

    // Outputs for tens and units of minutes
    assign minutes_tenth = minutes_OUT / 10;
    assign minutes_units = minutes_OUT % 10;

    // Outputs for tens and units of hours
    assign hours_tenth = hours_OUT / 10;
    assign hours_units = hours_OUT % 10;

endmodule
