module adder32(A,B,CIN,S,COUT);
input[31:0] A,B;
input CIN;
output[31:0] S;
output COUT;
wire[6:0] ci;
adder4o a0(A[3:0],B[3:0],CIN,S[3:0],ci[0]);
adder4o a1(A[7:4],B[7:4],ci[0],S[7:4],ci[1]);
adder4o a2(A[11:8],B[11:8],ci[1],S[11:8],ci[2]);
adder4o a3(A[15:12],B[15:12],ci[2],S[15:12],ci[3]);
adder4o a4(A[19:16],B[19:16],ci[3],S[19:16],ci[4]);
adder4o a5(A[23:20],B[23:20],ci[4],S[23:20],ci[5]);
adder4o a6(A[27:24],B[27:24],ci[5],S[27:24],ci[6]);
adder4o a7(A[31:28],B[31:28],ci[6],S[31:28],COUT);
endmodule