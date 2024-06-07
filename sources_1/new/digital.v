`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2024 09:20:09 PM
// Design Name: 
// Module Name: digital
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


module digital(
    input change,
    input up,
    input minhr,
    input set,
    input load,
    input resume,
    input sw,
    input stop,
    input snooze,
    input clk,
    input alarm,
    input clr,
    input timer,
    output reg [7:0]sec,
    output reg [6:0] LED_out,
    output reg [3:0] an,
    output reg alm
    );
    reg [15:0]timer_time;
    clkdivider ck(.clk100Mhz(clk),.clk(clk1));
    milli m(.clk100Mhz(clk),.clk100Hz(clk2));
    disp d(.clk100Mhz(clk),.clk(clk3));
    reg select,r;
    wire [23:0]t1,t2;
    reg [15:0]t_in,t_out;
    reg [3:0]val;
    wire [4:0] sec1=0110,min0=1101,min1=0011,sec0=1111;
    /////////////////////////////////////////////////////////////////////
    //getting t_in
    always@(posedge change,posedge clr)
    begin
        if(clr&set)
        begin
            t_in<=0;
        end
        else if(up&set&~minhr)
        begin
            if(t_in==16'h2359)
            begin
                t_in<=16'h0000;
            end
            else if(t_in[7:0]==8'h59)
            begin
                t_in[7:0]<=8'h00;
                t_in[15:8]<=t_in[15:8]+1;
            end
            else if(t_in[3:0]==4'h9)
            begin
                t_in[3:0]<=4'h0;
                t_in[7:4]<=t_in[7:4]+1;
            end
            else
            begin
                t_in<=t_in+16'h0001;
            end
        end
        else if(~up&set&~minhr)
        begin
            if(t_in==16'h0000)
            begin
                t_in<=16'h2359;
            end
            else if(t_in[7:0]==8'h00)
            begin
                t_in[7:0]<=8'h59;
                t_in[15:8]<=t_in[15:8]-1;
            end
            else if(t_in[3:0]==4'h0)
            begin
                t_in[3:0]<=4'h9;
                t_in[7:4]<=t_in[7:4]-1;
            end
            else
            begin
                t_in<=t_in-16'h0001;
            end
        end
        else if(up&set&minhr)
        begin
            if(t_in[15:8]==8'h23)
            begin
                t_in[15:8]<=8'h0;
            end
            else if(t_in[11:8]==4'h9)
            begin
                t_in[11:8]<=4'h0;
                t_in[15:12]<=t_in[15:12]+1;
            end
            else
            begin
                t_in[15:8]<=t_in[15:8]+8'h01;
            end
        end
        else if(~up&set&minhr)
        begin
            if(t_in[15:8]==8'h00)
            begin
                t_in[15:8]<=8'h23;
            end
            else if(t_in[11:8]==4'h0)
            begin
                t_in[11:8]<=4'h9;
                t_in[15:12]<=t_in[15:12]-1;
            end
            else
            begin
                t_in[15:8]<=t_in[15:8]-8'h01;
            end
        end
    end   
    ////////////////////////////timer//////////////////////////////////
    always@(posedge clk1,posedge sw)
    begin
        if(sw&timer)
        begin
            timer_time<=t_in;
        end
        else if(timer)
        begin
           if(timer_time[7:0]==8'h00&~(timer_time[15:8]==8'h00))
            begin
                timer_time[7:0]<=8'h59;
                timer_time[15:8]<=timer_time[15:8]-1;
            end
            else if(timer_time[3:0]==4'h0&~(timer_time[15:0]==16'h0000))
            begin
                timer_time[3:0]<=4'h9;
                timer_time[7:4]<=timer_time[7:4]-1;
            end
            else if(~(timer_time==16'h0000))
            begin
                timer_time<=timer_time-16'h0001;
            end
        end
    end
    ///////////////////////////////clock/////////////////////////////////
    clock c(.t_in(t_in),.load(load),.clk(clk1),.clr(clr),.t_out(t1));
    reg [1:0]k;
    stop_watch s(.load(sw),.clr(clr),.clk(clk2&~r),.t_out(t2));
    
    always@(posedge sw)
    begin
        select<=~select;
    end
    always@(posedge resume)
    begin
        r<=~r;
    end
    
    
    //////////////////////////////////////////alarm////////////////////////////////////////
    reg [15:0]alarm_time;
    always@(posedge alarm,posedge clr,posedge snooze)
    begin
        if(clr==1)
        begin
            alarm_time<=16'h0;
        end
        else if(snooze==1)
        begin
            alarm_time<=alarm_time+16'h0005;
        end
        else
        begin
            alarm_time<=t_in;
        end
    end
    always@(posedge clk1)
    begin
        if(alarm==1&~stop)
        begin
            if(alarm_time==t1[23:8])
            begin
                alm<=~alm;
            end
            else
            begin
                alm<=1;
            end
        end
        else
        begin
            alm<=0;
        end
    end
    ////////////////////////////////////////////////////////
    always@(posedge clk3)
    begin
        t_out<=select?(timer?timer_time:t2[15:0]):(set?t_in[15:0]:t1[23:8]);
        sec<=select?t2[23:16]:t1[7:0];
        // defining val and anode pins
        case(k)
        2'b00:
        begin
            an<=sec0;
            val<=t_out[3:0];
        end
        2'b01:
        begin
            an<=sec1;
            val<=t_out[7:4];
        end
        2'b10:
        begin
            an<=min0;
            val<=t_out[11:8];
        end
        2'b11:
        begin
            an<=min1;
            val<=t_out[15:12];
        end
        default
        begin
            an<=sec0;
            val<=t_out[3:0];
        end
        endcase
        
        // defining ledpinouts
        case(val)
        4'h0: LED_out=7'b1000000;//0
        4'h1: LED_out=7'b1111001;//1
        4'h2: LED_out=7'b0100100;//2
        4'h3: LED_out=7'b0110000;//3
        4'h4: LED_out=7'b0011001;//4
        4'h5: LED_out=7'b0010010;//5
        4'h6: LED_out=7'b0000010;//6
        4'h7: LED_out=7'b1111000;//7
        4'h8: LED_out=7'b0000000;//8
        4'h9: LED_out=7'b0010000;//9 
        endcase
        k<=k+1;
    end
endmodule
