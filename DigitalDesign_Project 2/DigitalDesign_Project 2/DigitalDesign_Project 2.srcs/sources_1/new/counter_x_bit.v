/***********************
*
* Module: counter_x_bit.v
* Project: Digital Design (Project 2)
Create Date: 04/22/2024 04:48:10 PM

* Author: Adham Ali/ adhamahmed804@aucegypt.edu 
          Omar Saqr/ omar_saqr@aucegypt.edu 
          Ebram Thabet / ebram_raafat@aucegypt.edu 
          
*Description:  Generic counter module with configurable width and maximum count value  
************************/
module counter_x_bit #(parameter x = 3, n = 6)(
    input clk,       
    input reset,     
    input en,        
    input Up_down,   
    output [x-1:0] count  
);

    reg [x-1:0] count;  // Register to hold the count value
    
    always @(posedge clk or posedge reset) begin
        // Synchronous reset condition
        if (reset == 1) begin
            count <= 0;  // Reset the count to zero
        end
        else begin
            // Check if the counter is enabled
            if (en == 1) begin
                // If Up_down is high, count up
                if (Up_down == 1) begin
                    // Check if count reached maximum value
                    if (count == n - 1) begin
                        count <= 0;  // Reset count if maximum reached
                    end
                    else begin
                        count <= count + 1;  // Increment count
                    end
                end
                else begin
                    // If Up_down is low, count down
                    // Check if count reached minimum value
                    if (count == 0) begin
                        count <= n - 1;  // Reset count to maximum if minimum reached
                    end
                    else begin
                        count <= count - 1;  // Decrement count
                    end
                end
            end
            // If counter is not enabled, maintain the current count value
            else begin
                count <= count;
            end
        end
    end

endmodule
