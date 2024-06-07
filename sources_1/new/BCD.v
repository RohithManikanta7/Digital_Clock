`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/04/2024 11:51:26 PM
// Design Name: 
// Module Name: counter
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


module counter(
    input clk,
    input clr,
    input [3:0]pst,
    input load,
    output reg [3:0] q
    );
    always@(negedge clk,posedge clr,posedge load)
    begin
        if(clr)
        begin
            q<=4'h0;
        end
        else if(load)
        begin
            q<=pst;
        end
        else if(q==4'h9)
        begin
            q<=0;
        end
        else
        begin
            q<=q+1;
        end
    end
endmodule
