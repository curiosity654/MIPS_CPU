module CPU_0tb;
  reg system_clk,reset;
  reg[7:0] switch;
  wire[3:0] AN;
  wire[7:0] digital,led;
CPU_0 cpu(system_clk,reset,switch,led,AN,digital);
always #1 system_clk=~system_clk;
initial begin
  system_clk=0;
  reset=1;
  switch=8'b1100_1000;
  #10 reset=0;
 end
endmodule