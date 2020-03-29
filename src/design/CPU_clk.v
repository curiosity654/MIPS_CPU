module CPU_clk(system_clk,reset,clk);
  input system_clk,reset;
  output reg clk;
  reg[6:0] count;
  initial begin count=7'b0;clk=1'b0; end
  always @(posedge system_clk,posedge reset)
   begin
    if(reset) count<=7'b0;
    else
     begin
      if(count==7'b1100011) 
       begin clk=~clk; count<=7'b0; end
      else count<=count+1;
     end
   end
endmodule