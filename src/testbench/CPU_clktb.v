module CPU_clktb;
  reg system_clk,reset;
  wire clk;
  CPU_clk clock(system_clk,reset,clk);
  always #5 system_clk=~system_clk;
  initial begin 
    system_clk=1; reset=1;
    #20 reset=0;
  end
endmodule