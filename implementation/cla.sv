module cla(A, B, C, S, P, G);

input A, B, C;
output S, P, G;

assign S = A ^ B ^ C;
assign P = A | B;
assign G = A & B;

endmodule
