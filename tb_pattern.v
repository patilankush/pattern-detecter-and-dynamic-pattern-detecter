`include"pattern1.v"
module tb;
reg clk,rst,d_in,valid_i;
wire pattern;
integer count;

pattern_det dut(.clk(clk), .rst(rst), .d_in(d_in), .valid_i(valid_i), .pattern(pattern));

initial begin
	clk=0;
	forever	#5 clk= ~clk;
end
initial begin
	rst=1;
	count=0;
	#20;
	rst=0;
	repeat(1000)begin
		@(posedge clk);
		d_in=$random;
		valid_i=1;
	end
	@(posedge clk);
	valid_i=0;
	d_in=0;
	#50;
	$display("count=%0d",count);
	$finish;
end
always@(posedge pattern)begin
	count=count+1;
end
endmodule	
