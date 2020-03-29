module ALU(A,B,ALUfun,Sign,S);
  input[31:0] A,B;
  input[5:0] ALUfun;
  input Sign;
  output[31:0] S;
  wire[31:0] adder,logic,shift,compare;
             //ALUfun[5:4]: 00->adder; 01->logic; 10->shift; 11->compare;
  wire zero,neg;
  ALU_adder ad(Sign,A,B,ALUfun[0],adder,zero,neg);
  ALU_logic lo(A,B,ALUfun[3:1],logic);
  ALU_shift sh(A,B,ALUfun[1:0],shift);
  ALU_compare co(zero,neg,ALUfun[3:1],compare);
  mux4_1 mux(.c0(adder),.c1(logic),.c2(shift),.c3(compare),.s(ALUfun[5:4]),.y(S));
endmodule