module ALU_shift(A,B,ALUfun,S);
  input[31:0] A,B;
  input[1:0] ALUfun; //ALUfun[1:0] 00->SLL; 01->SRL; 11->SRA
  output[31:0] S;
  wire[31:0] sf2,sf4,sf8,sf16;
  shift_16 s16(B,A[4],ALUfun,sf16);
  shift_8 s8(sf16,A[3],ALUfun,sf8);
  shift_4 s4(sf8,A[2],ALUfun,sf4);
  shift_2 s2(sf4,A[1],ALUfun,sf2);
  shift_1 s1(sf2,A[0],ALUfun,S);
endmodule