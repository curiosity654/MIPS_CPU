module CPU_PCtb;
  reg ALUOut,clk,reset;
  reg[2:0] PCSrc;
	reg[25:0] JT;
	reg[31:0] DatabusA,ConBA;
	wire[31:0] PC;
	CPU_PC update(clk,PCSrc,ALUOut,JT,ConBA,DatabusA,reset,PC);
	always #5 clk=~clk;
	initial begin
	  clk=1;
	  reset=0;
	  ALUOut=1;
	  ConBA=32'b1000_0000_0000_0000_0000_0000_1000_0000;
	  DatabusA=32'b1000_0000_0000_0000_0000_0100_0000_0000;
	  JT=26'b00_0000_0000_0000_0000_0010_0000;
	  PCSrc=3'b000;
	  #10 PCSrc=3'b001;
	  #10 ALUOut=0;
	  #10 PCSrc=3'b010;
	  #10 PCSrc=3'b011;
	  #10 PCSrc=3'b100;
	  #10 PCSrc=3'b101;
	  end
	endmodule