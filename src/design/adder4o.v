module adder4o(A,B,CIN,S,COUT);
  input[3:0] A,B;
  input CIN;
  output[3:0] S;
  output COUT;
  wire[2:0] CO;
  wire[3:0] p,g;
  assign p=A^B;
  assign g=A&B;
  assign CO[0]=g[0]|(p[0]&CIN);
  assign CO[1]=g[1]|(g[0]&p[1])|(p[1]&p[0]&CIN);
  assign CO[2]=g[2]|(g[1]&p[2])|(g[0]&p[1]&p[2])|(p[2]&p[1]&p[0]&CIN);
  assign COUT=g[3]|(g[2]&p[3])|(g[1]&p[2]&p[3])|(g[0]&p[1]&p[2]&p[3])|(p[3]&p[2]&p[1]&p[0]&CIN);
  adder3_2 a0(.x(A[0]),.y(B[0]),.cin(CIN),.s(S[0]));
  adder3_2 a1(.x(A[1]),.y(B[1]),.cin(CO[0]),.s(S[1]));
  adder3_2 a2(.x(A[2]),.y(B[2]),.cin(CO[1]),.s(S[2]));
  adder3_2 a3(.x(A[3]),.y(B[3]),.cin(CO[2]),.s(S[3]));
endmodule