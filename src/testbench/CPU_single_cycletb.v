module CPU_single_cycletb;
  reg clk,reset;
  reg[7:0] switch;
  wire[3:0] AN;
  wire[7:0] digital,led;
CPU_single_cycle CPU(clk,reset,switch,led,AN,digital);
always #1 clk=~clk;
initial begin
  clk=0;
  reset=1;
  switch=8'b1111_0101;
 #10 reset=0;
end
endmodule