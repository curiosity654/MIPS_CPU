module ALU_logic(A,B,ALUfun,S);
  input[31:0] A,B;
  input[2:0] ALUfun; //ALUfun[3:1] 
                     //100->A&B; 111->A|B; 011->A^B; 000->~(A|B); 101->A;
  output[31:0] S;
  wire[31:0] logic1,logic2;
  mux4_1 m1(.c0(A&B),.c1(A),.c2(0),.c3(A|B),.s(ALUfun[1:0]),.y(logic1));
  mux2_1 m2(.a(~(A|B)),.b(A^B),.s(ALUfun[0]),.y(logic2));
  mux2_1 m3(.a(logic2),.b(logic1),.s(ALUfun[2]),.y(S));
endmodule