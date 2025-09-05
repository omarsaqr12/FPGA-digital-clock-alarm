/***********************
*
Create Date: 05/7/2024 04:46:10 PM

* Module: clockDivider.v
* Project: Digital Design (Project 2)

* Author: Adham Ali/ adhamahmed804@aucegypt.edu 
          Omar Saqr/ omar_saqr@aucegypt.edu 
          Ebram Thabet / ebram_raafat@aucegypt.edu 
          
*Description: Clock divider module that generates an output clock signal with a frequency divided by 'n' 
************************/

module clockDivider #(parameter n = 50000000)(
    input clk, 
    rst, 
    output reg clk_out
);
    wire [31:0] count;
    // Big enough to hold the maximum possible value
    // Increment count
    counter_x_bit #(32,n) counterMod(.clk(clk), .reset(rst),.en(1'b1), .Up_down (1'b1),.count(count));
    // Handle the output clock
    always @ (posedge clk, posedge rst) begin
    if (rst) // Asynchronous Reset
    clk_out <= 0;
    else if (count == n-1)
    clk_out <= ~ clk_out;
    end
endmodule