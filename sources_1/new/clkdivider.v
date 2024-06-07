module clkdivider(
		input clk100Mhz,
		output reg clk
		);
reg [25:0] count;
always@(negedge clk100Mhz)
begin
    count<=count+1;
    if (count==50000000)
    begin
        count<=0;
        clk<=~clk;
    end
end
endmodule