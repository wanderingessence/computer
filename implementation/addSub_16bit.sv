module addsub_16bit(sum, ovfl, a, b, sub, cin);
input[15:0] a;
input[15:0] b;
input cin;
input sub;
output ovfl;
output[15:0] sum;

wire[15:0] B_sub;

assign B_sub = (sub) ? ~b : b;
assign cin = (sub) ? 1 : 0;

CLA_16bit add(.A(a), .B(b), .Cin(cin), .S(sum), .Cout(), .Ovfl(ovfl));

endmodule
