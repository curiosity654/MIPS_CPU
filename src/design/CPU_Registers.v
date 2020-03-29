module CPU_Registers(clk,reset,AddrA,AddrB,AddrC,WrC,WriteDataC,PC,IRQ,ReadDataA,ReadDataB);
  input clk,reset,WrC,IRQ;
  input[4:0] AddrA,AddrB,AddrC;
  input[31:0] WriteDataC,PC;
  output[31:0] ReadDataA,ReadDataB;
  wire enable=~PC[31]&IRQ;
  wire[31:0] PC_plus;
  reg[31:0] Regis[31:1];
  integer i;
  
  assign PC_plus={PC[31],{PC[30:0]+31'b000_0000_0000_0000_0000_0000_0000_0100}};
  assign ReadDataA=(AddrA==5'b0)? 32'b0:Regis[AddrA];  //$0==0
  assign ReadDataB=(AddrB==5'b0)? 32'b0:Regis[AddrB];  
  initial begin for(i=1;i<32;i=i+1) Regis[i]=32'b0; end
  
  always @(posedge clk,posedge reset)
   begin
    if(reset) 
     begin for(i=1;i<32;i=i+1) Regis[i]=32'b0; end
    else
     begin 
      if(WrC&&AddrC) Regis[AddrC]<=WriteDataC;
      if(enable&&(~WrC|AddrC!=5'b11111)) Regis[31]<=PC_plus;
     end
   end
endmodule