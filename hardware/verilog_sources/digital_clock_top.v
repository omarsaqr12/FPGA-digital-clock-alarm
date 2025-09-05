`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Digital Clock with Alarm - FPGA Implementation
// Project: Digital Design Project 2
// Target Device: Basys 3 FPGA Board
// Authors: Adham Ali (adhamahmed804@aucegypt.edu)
//          Omar Saqr (omar_saqr@aucegypt.edu) 
//          Ebram Thabet (ebram_raafat@aucegypt.edu)
//          
// Description: Top-level module for implementing a digital clock with alarm 
//              functionality on seven-segment display with button controls
//////////////////////////////////////////////////////////////////////////////////

module digital_clock_top(
    input clk, 
    input reset,
    input enable, 
    output [3:0] anode_active ,
    output [6:0] segments, 
    output reg decimal, 
    input C, //BTNC
    input L, //BTNL
    input R, //BTNR
    input U, //BTNU
    input D,  //BTND
    output  reg[4:0]LD,
    output buzz_en
 );

    wire [3:0] clock_min_units;// minuites units
    wire [2:0] clock_min_tens;// minuites tens
    wire [3:0] clock_hr_units;// hours units
    wire [1:0] clock_hr_tens;// hours_tenth
    
    wire [3:0] alarm_min_units;// minuites units
    wire [2:0] alarm_min_tens;// minuites tens
    wire [3:0] alarm_hr_units;// hours units
    wire [1:0] alarm_hr_tens;// hours_tenth
    
    
    wire [1:0] sel, sel2;
    
    //we have 2 types of clock and the selector clock choses which clock in which state
    wire clk_out;
    reg selector_clk;
    wire clk_200_hz;
    
    clockDivider #(250000) button_clk (.clk(clk),.rst(reset),.clk_out(clk_200_hz)); 
    clockDivider #(50000000) clkhz (.clk(clk),.rst(reset),.clk_out(clk_out)); 
    
    reg sec_en , min_en ,hour_en , alarm_min_en , alarm_hour_en, Up_down; //Wires used in the finite state machines 
    wire out1, out2, out3, out4, out5; 
    
    
    
    reg [2:0] state, nextstate;
    parameter [2:0] display_clock = 3'b000, alarm_mode = 3'b001,
    clk_hour = 3'b010, clk_min = 3'b100, alarm_hour = 3'b110, alarm_min = 3'b111;
    // making the pushbuttons
      Push_buttondetector Up (.clk_in(clk_200_hz), .rst(reset), .in(U), .out(out1));
      Push_buttondetector Down (.clk_in(clk_200_hz), .rst(reset), .in(D), .out(out2));
      Push_buttondetector Right (.clk_in(clk_200_hz), .rst(reset), .in(R), .out(out3));
      Push_buttondetector Left (.clk_in(clk_200_hz), .rst(reset), .in(L), .out(out4));
      Push_buttondetector Clock_disp (.clk_in(clk_200_hz), .rst(reset), .in(C), .out(out5));
    wire [4:0] usedoutput = {out1, out2, out3, out4, out5}; //concatonating the out wires to use it in the state machines, made us know which button we are
    
    
    always@(*) begin //here is representing the decimal value
        if(anode_active==4'b1101 & clk_out &(state==display_clock | state ==alarm_mode))// this condition is to represent the decimal at the display_clock and the alarm
            decimal=0;
            else
            decimal=1;
        end
        
     wire z_flag; // condition that makes the program enter the alarm mode
        
     wire[5:0]seconds_OUT; // used in the z flag  
    
    assign buzz_en = (state==alarm_mode) ? LD[0] : 0 ;//The bonus part,. the buzzer is working when LD[0] is in the alarm mode
    
    assign z_flag = ((clock_hr_units == alarm_hr_units) & (clock_min_units == alarm_min_units)
    & (clock_min_tens == alarm_min_tens)& (clock_hr_tens == alarm_hr_tens) & (seconds_OUT==0) ); // this the condition which makes us enter the alarm mode
        
    
    //Here is the finite state machines (MEALY), every state has special conditions
    always @* begin 
        case (state)
        display_clock :begin
        if (z_flag)begin
              LD = {0,0,0,0,clk_out}; //Blinking at LD[0]
              nextstate = alarm_mode;
              selector_clk=clk_out;
              sec_en=1;
              Up_down=1'b1;
              min_en=0;
              hour_en=0;
              alarm_min_en=0;
              alarm_hour_en=0; 
        end 
        else if (usedoutput == 5'b00001) begin 
            nextstate = clk_hour;
            LD=5'b10001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
             
          end
          else begin 
            nextstate = display_clock;
            LD=5'b00000;
            selector_clk=clk_out;
            sec_en=1;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          end
        
          clk_hour: begin 
          if (usedoutput == 5'b00100) begin 
            nextstate = clk_min;
            LD=5'b01001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          
         else if (usedoutput == 5'b00010) begin 
            nextstate = alarm_min;
            LD=5'b00011;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          
          else if (usedoutput == 5'b00001) begin 
            nextstate = display_clock;
            LD=5'b00000;
            selector_clk=clk_out;
            sec_en=1;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
         
          else if (usedoutput == 5'b10000)  begin 
            nextstate = clk_hour;
            LD=5'b10001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=1;
            alarm_min_en=0;
            alarm_hour_en=0;  
          end
          
          
          else if (usedoutput == 5'b01000) begin 
            nextstate = clk_hour;
            LD=5'b10001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b0;
            min_en=0;
            hour_en=1;
            alarm_min_en=0;
            alarm_hour_en=0; 
          end
            
          else begin 
            nextstate = clk_hour;
            LD=5'b10001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          end 
          
           
          clk_min: begin
          if (usedoutput == 5'b00100) begin 
            nextstate = alarm_hour;
            LD=5'b00101;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end 
           else if (usedoutput == 5'b00010)begin 
            nextstate = clk_hour;
            LD=5'b10001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          else if (usedoutput == 5'b00001) begin 
            nextstate = display_clock;
            LD=5'b00000;
            selector_clk=clk_out;
            sec_en=1;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          else if (usedoutput == 5'b10000) begin 
            nextstate = clk_min;
            LD=5'b01001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=1;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          else if (usedoutput == 5'b01000)begin 
            nextstate = clk_min;
            LD=5'b01001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b0;
            min_en=1;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          else begin 
            nextstate = clk_min;
            LD=5'b01001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          end
          
          
          alarm_hour: begin        
          if (usedoutput == 5'b00100) begin 
            nextstate = alarm_min;
            LD=5'b00011;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
           else if (usedoutput == 5'b00010) begin 
            nextstate = clk_min;
            LD=5'b01001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          else if (usedoutput == 5'b00001) begin 
            nextstate = display_clock;
            LD=5'b00000;
            selector_clk=clk_out;
            sec_en=1;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          else if (usedoutput == 5'b10000) begin 
            nextstate = alarm_hour;
            LD=5'b00101;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=1;
          end
          else if (usedoutput == 5'b01000) begin 
            nextstate = alarm_hour;
            LD=5'b00101;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b0;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=1;
          end
          else begin 
            nextstate = alarm_hour;
            LD=5'b00101;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          end
           
                
          alarm_min: begin 
          if (usedoutput == 5'b00100)begin 
            nextstate = clk_hour;
            LD=5'b10001;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          else if (usedoutput == 5'b00010) begin 
            nextstate = alarm_hour;
            LD=5'b00101;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          else if (usedoutput == 5'b00001) begin 
            nextstate = display_clock;
            LD=5'b00000;
            selector_clk=clk_out;
            sec_en=1;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0; 
          end
          else if (usedoutput == 5'b10000)begin 
            nextstate = alarm_min;
            LD=5'b00011;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=1;
            alarm_hour_en=0;
          end  
          else if (usedoutput == 5'b01000)begin
            nextstate = alarm_min;
            LD=5'b00011;
            selector_clk=clk_200_hz;
            sec_en=0;
            Up_down=1'b0;
            min_en=0;
            hour_en=0;
            alarm_min_en=1;
            alarm_hour_en=0;
          end
          else begin 
            nextstate = alarm_min;
            LD=5'b00011;
            selector_clk=clk_out;
            sec_en=0;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;
          end
          end
          
          alarm_mode:
          if (usedoutput != 5'b00000) begin 
            nextstate = display_clock;
            LD=5'b00000;
            selector_clk=clk_out;
            sec_en=1;
            Up_down=1'b1;
            min_en=0;
            hour_en=0;
            alarm_min_en=0;
            alarm_hour_en=0;  
          end 
          else begin 
              LD = {0,0,0,0,clk_out}; // blinking at LD[0]
              nextstate = alarm_mode;
              selector_clk=clk_out;
              sec_en=1;
              Up_down=1'b1;
              min_en=0;
              hour_en=0;
              alarm_min_en=0;
              alarm_hour_en=0;
          end
          
          default: nextstate = display_clock;
    
        endcase
      end 
       
    reg [3:0] display4 , display3, display2, display1;
    
    
    //this always block is like a multiplexor that chose wether we will display the alarm or the clock
    always @(state) begin
        case(state)
        alarm_hour:begin
        display4 = alarm_min_units;
        display3 = alarm_min_tens;
        display2 = alarm_hr_units;
        display1 = alarm_hr_tens;
        end
        alarm_min: begin
        display4 = alarm_min_units;
        display3 = alarm_min_tens;
        display2 = alarm_hr_units;
        display1 = alarm_hr_tens;
        end
        
        clk_hour:begin
        display4 = clock_min_units;
        display3 = clock_min_tens;
        display2 = clock_hr_units;
        display1 = clock_hr_tens;
        end
        clk_min:begin
        display4 = clock_min_units;
        display3 = clock_min_tens;
        display2 = clock_hr_units;
        display1 = clock_hr_tens;
        end
        display_clock:begin
        display4 = clock_min_units;
        display3 = clock_min_tens;
        display2 = clock_hr_units;
        display1 = clock_hr_tens;
        end
        alarm_mode:begin
        display4 = clock_min_units;
        display3 = clock_min_tens;
        display2 = clock_hr_units;
        display1 = clock_hr_tens;
        end
        
        endcase
    end
    
     //this if we pressed reset it will go to the display_clock state 
    always @(posedge clk_200_hz or posedge reset) begin 
        if (reset) begin 
          state <= display_clock; 
        end 
        else begin 
          state <= nextstate; 
        end 
      end 
    
      //the modules used to make the alarm, clock and displaying them on seven segment display
    Clock_Counter clock(selector_clk, reset, min_en,hour_en, sec_en, Up_down,clock_hr_units, clock_min_units, clock_hr_tens, clock_min_tens,seconds_OUT);
    
    Alarm_Counter alarm(clk_200_hz, reset, alarm_min_en, alarm_hour_en, Up_down, alarm_hr_units, alarm_min_units, alarm_hr_tens,alarm_min_tens);
    
    counter_x_bit #(2,4) gut(.clk(clk_200_hz), .reset(reset),.en(1'b1),.Up_down(1'b1), .count(sel)); //multiplexed display
    
    seven_segment_display finalOutput(.inp1(display4),.inp2({display3}),.inp3(display2),.inp4({display1}),.enable(sel),.anode_active(anode_active),.segments(segments)); 
  
endmodule
