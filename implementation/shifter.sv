module shifter(shift_out, shift_in, shift_val, mode);

input[15:0] shift_in;
input[3:0] shift_val;
input [1:0] mode;
output reg [15:0] shift_out;

typedef enum reg [1:0] {SLL, SRA, ROR} mode_t;

wire [15:0] stage_1_SLL, stage_2_SLL, stage_3_SLL, stage_4_SLL;
wire [15:0] stage_1_SRA, stage_2_SRA, stage_3_SRA, stage_4_SRA;
wire [15:0] stage_1_ROR, stage_2_ROR, stage_3_ROR, stage_4_ROR;


//shift left logical portion
assign stage_1_SLL = shift_val[0] ? shift_in << 1 : shift_in;
assign stage_2_SLL = shift_val[1] ? stage_1_SLL << 2 : stage_1_SLL;
assign stage_3_SLL = shift_val[2] ? stage_2_SLL << 4 : stage_2_SLL;
assign stage_4_SLL = shift_val[3] ? stage_3_SLL << 8 : stage_3_SLL;

//barrel shifter shift right arithmetic
assign stage_1_SRA = shift_val[0] ? {shift_in[15] , shift_in[15:1]} : shift_in;
assign stage_2_SRA = shift_val[1] ? {{2{stage_1_SRA[15]}}, stage_1_SRA[15:2]} : stage_1_SRA;
assign stage_3_SRA = shift_val[2] ? {{4{stage_2_SRA[15]}}, stage_2_SRA[15:4]} : stage_2_SRA;
assign stage_4_SRA = shift_val[3] ? {{8{stage_3_SRA[15]}}, stage_3_SRA[15:8]} : stage_3_SRA;


//rotate right
assign stage_1_ROR = shift_val[0] ? {shift_in[0], shift_in[15:1]} : shift_in;
assign stage_2_ROR = shift_val[1] ? {stage_1_ROR[1:0], stage_1_ROR[15:2]} : stage_1_ROR;
assign stage_3_ROR = shift_val[2] ? {stage_2_ROR[3:0], stage_2_ROR[15:4]} : stage_2_ROR;
assign stage_4_ROR = shift_val[3] ? {stage_3_ROR[7:0], stage_3_ROR[15:8]} : stage_3_ROR;
 


always_comb begin
	case(mode)
		SLL: shift_out = stage_4_SLL;
		SRA: shift_out =  stage_4_SRA;
		ROR: shift_out = stage_4_ROR; 
	endcase
end


endmodule
