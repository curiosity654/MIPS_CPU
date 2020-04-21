module IFID(clk,reset,PC,Instruct,Stall,IFIDWrite,IFID_PC, IFID_Instruct);
  input clk, reset, Stall, IFIDWrite;
  input[31:0] PC, Instruct;
  output reg[31:0] IFID_PC, IFID_Instruct;
  wire[31:0] IFIDW;
  assign IFIDW=IFIDWrite? Instruct:IFID_Instruct;
  always @(posedge clk,posedge reset)
   begin
    if(reset)
     begin
         IFID_PC<=32'b0;
         IFID_Instruct<=32'b0;
     end
    else
     begin 
      IFID_PC<=PC;
      IFID_Instruct<=Stall? 32'b0:IFIDW;
     end
   end    
endmodule