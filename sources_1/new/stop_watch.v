`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/11/2024 12:53:16 PM
// Design Name: 
// Module Name: stop_watch
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


module stop_watch(
    input load,
    input clr,
    input clk,
    output [23:0] t_out
    );
    //millisecond
    counter c1(.clk(clk),.clr(clr),.pst(4'h0),.load(load),.q(t_out[3:0]));
    counter c2(.clk(t_out[3]),.clr(clr),.pst(4'h0),.load(load),.q(t_out[7:4]));
    //seconds
    counter c3(.clk(t_out[7]),.clr(clr),.pst(4'h0),.load(load),.q(t_out[11:8]));
    counter c4(.clk(t_out[11]),.clr(clr|(t_out[15:12]==4'h6)),.pst(4'h0),.load(load),.q(t_out[15:12]));
    //minutes
    counter c5(.clk(t_out[14]),.clr(clr),.pst(4'h0),.load(load),.q(t_out[19:16]));
    counter c6(.clk(t_out[19]),.clr(clr|(t_out[23:20]==4'h6)),.pst(4'h0),.load(load),.q(t_out[23:20]));
endmodule
