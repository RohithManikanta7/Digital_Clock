`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2024 04:50:10 PM
// Design Name: 
// Module Name: clock
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


module clock(
    input  [15:0] t_in,
    input load,
    input clk,
    input clr,
    output [23:0] t_out
    );
    //seconds
    counter c1(.clk(clk),.clr(clr),.pst(4'h0),.load(load),.q(t_out[3:0]));
    counter c2(.clk(t_out[3]),.clr(clr|(t_out[7:4]==4'h6)),.pst(4'h0),.load(load),.q(t_out[7:4]));
    //minutes
    counter c3(.clk(t_out[6]),.clr(clr),.pst(t_in[3:0]),.load(load),.q(t_out[11:8]));
    counter c4(.clk(t_out[11]),.clr(clr|(t_out[15:12]==4'h6)),.pst(t_in[7:4]),.load(load),.q(t_out[15:12]));
    //hours
    
    counter c5(.clk(t_out[14]),.clr(clr|(t_out[23:16]==8'h24)),.pst(t_in[11:8]),.load(load),.q(t_out[19:16]));
    counter c6(.clk(t_out[19]),.clr(clr|(t_out[23:16]==8'h24)),.pst(t_in[15:12]),.load(load),.q(t_out[23:20]));
endmodule
