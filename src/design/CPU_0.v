module CPU_0(system_clk,reset,switch,led,AN,digital);
  input system_clk,reset;
  input[7:0] switch;
  output[7:0] led,digital;
  output[3:0] AN;
  wire clk;
  CPU_clk clock(system_clk,reset,clk);
  CPU_single_cycle CPU(clk,reset,switch,led,AN,digital);
endmodule