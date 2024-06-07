`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/12/2024 03:02:32 PM
// Design Name: 
// Module Name: milli_second
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


module disp(
    input clk100Mhz,
    output reg clk
    );
    reg [16:0] count;
    always@(negedge clk100Mhz)
    begin
        if(count==50000)
        begin
            clk<=~clk;
            count<=0;
        end
        count=count+1;
    end
endmodule
