/***********************
*
* Module: seven_segment.v
* Project: Digital Design (Project 2)
// Create Date: 04/22/2024 04:49:10 PM

* Author: Adham Ali/ adhamahmed804@aucegypt.edu 
          Omar Saqr/ omar_saqr@aucegypt.edu 
          Ebram Thabet / ebram_raafat@aucegypt.edu 
          
 *Description: Module for driving a four-digit seven-segment display           
************************/

module seven_segment_display(
    input [3:0] inp1, inp2, inp3, inp4,  
    input [1:0] enable,                   
    output reg [3:0] anode_active,        
    output reg [6:0] segments             
);

    integer x=0;  
    integer z=0;  
    reg [3:0] num; 
    
    always @ (num, enable) begin
        // Select the active digit based on the enable signal
        case(enable)
            2'b00: begin
                anode_active = 4'b0111;  
                num = inp1; 
            end
            2'b01: begin
                anode_active = 4'b1011;  
                num = inp2;  
            end
            2'b10: begin
                anode_active = 4'b1101;  
                num = inp3; 
            end
            2'b11: begin
                anode_active = 4'b1110;  
                num = inp4;  
            end
        endcase
    
        case(num)
            4'b0000: segments = 7'b0000001;  // Display '0'
            4'b0001: segments = 7'b1001111;  // Display '1'
            4'b0010: segments = 7'b0010010;  // Display '2'
            4'b0011: segments = 7'b0000110;  // Display '3'
            4'b0100: segments = 7'b1001100;  // Display '4'
            4'b0101: segments = 7'b0100100;  // Display '5'
            4'b0110: segments = 7'b0100000;  // Display '6'
            4'b0111: segments = 7'b0001111;  // Display '7'
            4'b1000: segments = 7'b0000000;  // Display '8'
            4'b1001: segments = 7'b0000100;  // Display '9'
            default: segments = 7'b1111111;   // Turn off all segments if the input is invalid
        endcase
    end
endmodule
