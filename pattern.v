module pattern_det(clk, rst, d_in, valid_i, pattern);   //moore machine :1 more state requred
parameter S_R = 3'b000;
parameter S_B = 3'b001;
parameter S_BB = 3'b010;
parameter S_BBC = 3'b011;      //in moore at waveform count happend after 1 clock, but in mealy it happend imediatly 
parameter S_BBCB = 3'b100;
parameter S_BBCBC = 3'b101;
parameter B = 0;
parameter C = 1;

input clk, rst, valid_i, d_in;
output reg pattern;

reg [2:0] state, next_state;

always @(next_state) begin
	state = next_state; //whenver next_state changes, update state with next_state value
end

always @(posedge clk) begin
if (rst) begin
	pattern = 0;
	state = S_R;
	next_state = S_R;
end
else begin
	pattern = 0;
if (valid_i == 1) begin
	case (state)
		S_R: begin
			if (d_in == B) next_state = S_B;
			if (d_in == C) next_state = S_R;
		end
		S_B: begin
			if (d_in == B) next_state = S_BB;
			if (d_in == C) next_state = S_R;
		end
		S_BB: begin
			if (d_in == B) next_state = S_BB;
			if (d_in == C) next_state = S_BBC;
		end
		S_BBC: begin
			if (d_in == B) next_state = S_BBCB;
			if (d_in == C) next_state = S_R;
		end
		S_BBCB: begin
			if (d_in == B) next_state = S_BB;
			if (d_in == C) next_state = S_BBCBC;
		end
		S_BBCBC: begin
			pattern = 1;
			if (d_in == B) next_state = S_B;
			if (d_in == C) next_state = S_R;
		end
	endcase
end
end
end
endmodule


