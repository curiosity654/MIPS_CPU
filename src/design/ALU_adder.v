module ALU_adder(sign,A,B,ALUfun,S,zero,neg);
input sign,ALUfun;  //ALUfun[0],0->add,1->sub
input[31:0] A,B;
output zero,neg;   
output[31:0] S;
wire[31:0] input_B;
wire over,cout;
wire ab_xor,ab_xnor,bs_xor,bs_xnor;
assign ab_xor=(A[31]&~B[31])|(~A[31]&B[31]);
assign ab_xnor=(A[31]&B[31])|(~A[31]&~B[31]);
assign bs_xor=(S[31]&~B[31])|(~S[31]&B[31]);
assign bs_xnor=(S[31]&B[31])|(~S[31]&~B[31]);
assign input_B=(ALUfun==1'b1)? ~B:B;
assign neg=(sign&S[31]&~over)|(~sign&ALUfun&~cout); //A-B<0 ->neg=1;
assign zero=~|(A^B); //A==B ->zero=1
assign over=sign&((ALUfun&ab_xor&bs_xnor)|(~ALUfun&ab_xnor&bs_xor));
adder32 add(A,input_B,ALUfun,S,cout);
endmodule