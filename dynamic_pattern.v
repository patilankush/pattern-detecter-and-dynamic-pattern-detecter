module dynamic(rst,clk,d_in,pattern_detected,valid_in);

input clk,rst,d_in,valid_in;
output reg pattern_detected;
parameter S_RESET= 6'b000001;
parameter S_DET_1BIT= 6'b000010;
parameter S_DET_2BIT= 6'b000100;
parameter S_DET_3BIT= 6'b001000;
parameter S_DET_4BIT= 6'b010000;
parameter S_DET_5BIT= 6'b100000;

parameter c= 1'b1;
parameter b= 1'b0;

reg[4:0]pattern_to_detect; //what is the pattern i want to detect //BBCBC : 00101
reg[4:0]pattern_collected;
reg[5:0]state , next_state;

always@(posedge clk)begin
if (rst==1)begin
	state= S_RESET;
	next_state= S_RESET;
	pattern_detected=0;
	pattern_collected=0;
	//pattern_to_detect=5'b00001; //BBBBC
	pattern_to_detect=5'b11001; //CCBBC
	//pattern_to_detect=5'b01010; //BCBCB
end
else begin
	pattern_detected=0;
	pattern_collected=pattern_collected << 1; //left shift whole pattern by 1 bit
	pattern_collected[0] = d_in;
		
	case(state)
		S_RESET : begin  //B : 0
			if(pattern_collected[0]== pattern_to_detect [4]) next_state= S_DET_1BIT;
			else next_state = S_RESET;
		end
		S_DET_1BIT :begin //BB :00
			if (pattern_collected[1:0]== pattern_to_detect[4:3]) next_state= S_DET_2BIT;
			else if(pattern_collected[0]==pattern_to_detect[4]) next_state= S_DET_1BIT;
			else next_state = S_RESET;
		end
	 	S_DET_2BIT : begin
		
			if (pattern_collected[2:0]== pattern_to_detect[4:2]) next_state= S_DET_3BIT; //we have 3 bits matching
			else if(pattern_collected[1:0]== pattern_to_detect[4:3]) next_state= S_DET_2BIT;
			else if(pattern_collected[0]==pattern_to_detect[4]) next_state= S_DET_1BIT;
			else next_state =S_RESET;
		end
		S_DET_3BIT: begin

			if (pattern_collected[3:0]== pattern_to_detect[4:1]) next_state= S_DET_4BIT;
			else if(pattern_collected[2:0]==pattern_to_detect[4:2]) next_state= S_DET_3BIT;
			else if(pattern_collected[1:0]==pattern_to_detect[4:3]) next_state= S_DET_2BIT;
			else if(pattern_collected[0]==pattern_to_detect[4]) next_state= S_DET_1BIT;
			else next_state =S_RESET;
		end
		S_DET_4BIT: begin
		
			if (pattern_collected[4:0]== pattern_to_detect[4:0]) next_state= S_DET_5BIT;
			else if(pattern_collected[3:0]==pattern_to_detect[4:1]) next_state= S_DET_4BIT;
			else if(pattern_collected[2:0]==pattern_to_detect[4:2]) next_state= S_DET_3BIT;
			else if(pattern_collected[0]==pattern_to_detect[4]) next_state= S_DET_1BIT;
			else next_state =S_RESET;
		end
		S_DET_5BIT: begin
			pattern_detected=1;
			//below code for non overlapping
			if(pattern_collected[0]==pattern_to_detect[4]) next_state= S_DET_1BIT;
			else next_state = S_RESET;
		end
	endcase
end
end
always @(next_state) begin
	state = next_state; //state should get updated with next_state , so that FSM will move forward
end
endmodule
