module CPU_Extendertb;
  reg[15:0] Imm16;
  reg EXTOp;
  wire[31:0] Imm32;  
CPU_Extender Ex(Imm16,EXTOp,Imm32);
  initial begin
    Imm16=16'b1001_0000_0001_0011;
    EXTOp=0;
    #50 EXTOp=1;
    #50 Imm16=16'b0001_0000_0001_0011;
    #50 EXTOp=0;
  end
endmodule