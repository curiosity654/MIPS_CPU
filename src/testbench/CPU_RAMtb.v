module CPU_RAMtb;
  reg clk,reset,MemRd,MemWr;
  reg[7:0] switch;
  reg[31:0] Addr,WriteData;
  wire[31:0] ReadData;
  wire[3:0] AN;
  wire[7:0] digital,led;
  wire inter;
CPU_RAM ram(clk,reset,switch,Addr,WriteData,MemRd,MemWr,ReadData,led,AN,digital,inter);
  always #5 clk=~clk;
  initial begin
    clk=1; reset=0; MemRd=0; MemWr=1;
    switch=8'b10110111;
    WriteData=32'b0111_0101_0110_1000_0000_0001_0101_0000;
    Addr=32'b0000_0000_0000_0000_0000_0000_0000_0000;
    #10 MemRd=1;
    #10 Addr=32'b0100_0000_0000_0000_0000_0000_0000_0000;
    #10 Addr=32'b0100_0000_0000_0000_0000_0000_0000_0100;
    #10 Addr=32'b0100_0000_0000_0000_0000_0000_0000_1000;
    #10 Addr=32'b0100_0000_0000_0000_0000_0000_0000_1100;
    #10 Addr=32'b0100_0000_0000_0000_0000_0000_0001_0000;
    #10 Addr=32'b0100_0000_0000_0000_0000_0000_0001_0100;
    #10 Addr=32'b1111_1111_1111_1111_1111_1111_1111_1111;
   end
endmodule