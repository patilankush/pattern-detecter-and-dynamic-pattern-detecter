`include"dynamic_pattern.v"
module tb;
reg clk, rst, d_in, valid_in;
wire pattern_detected;
integer count;
integer seed;
dynamic dut(rst,clk,d_in,pattern_detected,valid_in);
initial begin
	clk=0;
	forever #5 clk= ~clk;
end
initial begin
	rst=1;
	count =0;
	repeat (2) @(posedge clk);
	rst =0;
	seed= 5747854;
	repeat (500) begin
		@(posedge clk);
		d_in= $random(seed);
		//d_in = $random(8378657);
	end
	#100;
	$display("count=%d",count);
	$finish;
end
initial begin
	forever begin
		@(posedge pattern_detected);
		count= count+1;
	end
end
endmodule
