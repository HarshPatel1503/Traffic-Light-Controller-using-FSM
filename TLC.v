`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.08.2022 19:17:45
// Design Name: 
// Module Name: TLC
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
`define TRUE 1'b1 
`define FALSE 1'b0
//delays
`define y2rdelay 3
`define r2gdelay 2

module TLC(hwy,cntry,clk,clear,x);
input x,clk,clear;
output reg [1:0] hwy,cntry;

//status of light 
parameter red=2'b00;
parameter yellow=2'b01;
parameter green=2'b10;

//state definition          hwy    cntry
parameter S0=3'b000;     //   G       R
parameter S1=3'b001;     //   Y       R
parameter S2=3'b010;     //   R       R
parameter S3=3'b011;     //   R       G
parameter S4=3'b100;     //   R       Y

reg [2:0] state;
reg [2:0] next_state;

always@(posedge clk)
if(clear)
state<=S0;
else 
state<=next_state;

always@(state)
begin
      hwy=green; 
      cntry=red; 
case(state) 
S0: ;
S1: hwy=yellow;    
S2: hwy=red; 
S3: begin 
    hwy=red; 
    cntry=green;
    end
S4: begin 
    hwy=red; 
    cntry=yellow;
    end
endcase   
end  

always@(state or x)
begin 
case(state)
S0: if(x)
    next_state = S1;
    else 
    next_state=S0;
S1: begin 
repeat(`y2rdelay) next_state=S1;
next_state=S2;
end
S2: begin 
repeat(`r2gdelay) next_state=S2;
next_state=S3;
end
S3: if(x)
    next_state = S3;
    else 
    next_state=S4;
S4: begin 
repeat(`y2rdelay) next_state=S4;
next_state=S0;
end
default: next_state=S0;
endcase
end

endmodule
