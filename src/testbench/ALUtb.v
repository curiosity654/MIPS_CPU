module ALUtb;
  reg[31:0] A,B;
  reg[5:0] ALUfun;
  reg Sign;
  wire[31:0] S;
  ALU testALU(A,B,ALUfun,Sign,S);
  initial
   begin
     /*
     //test for adder:
     A=32'b1101_1010_1111_1011_0000_0010_0001_1001;
     B=32'b0010_0010_1011_0000_0100_0010_1101_0001; 
     Sign=1'b0;
     ALUfun=6'b000000; //add
     #50 ALUfun=6'b000001; //sub
     */
     /*
     //test for logic:
     A=32'b1101_1010_1111_1011_0000_0010_0001_1001;
     B=32'b0010_0010_1011_0000_0100_0010_1101_0001;
     Sign=1'b0;
     ALUfun=6'b011000;  //AND
     #50 ALUfun=6'b011110;  //OR
     #50 ALUfun=6'b010110;  //XOR
     #50 ALUfun=6'b010001;  //NOR
     #50 ALUfun=6'b011010;  //"A"
     */
     /*
     //test for shift:
     A=32'b0000_0000_0000_0000_0000_0000_0001_1001;
     B=32'b0010_0010_1011_0000_0100_0010_1101_0001;  //B[31]=0
     Sign=1'b0;
     ALUfun=6'b100000;  //SLL
     #50 ALUfun=6'b100001;  //SRL
     #50 ALUfun=6'b100011;  //SRA
     #50 B=32'b1010_0010_1011_0000_0100_0010_1101_0001;  //B[31]=1
     */
     //test for compare:
     A=32'b0010_0010_1011_0000_0100_0010_1101_0001;
     B=32'b0010_0010_1011_0000_0100_0010_1101_0001;
     Sign=1'b0;
     ALUfun=6'b110011;  //EQ;
     #50 ALUfun=6'b110001;  //NEQ
     #50 ALUfun=6'b110101;  //LT
     #50 B=32'b0000_0000_0000_0000_0000_0000_0000_0000;
     ALUfun=6'b111101;  //LEZ
     #50 ALUfun=6'b111001;  //GEZ
     #50 ALUfun=6'b111111;  //GTZ
   end
 endmodule