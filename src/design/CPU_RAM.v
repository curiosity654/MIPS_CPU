module CPU_RAM(clk,reset,switch,Addr,WriteData,MemRd,MemWr,ReadData,led,AN,digital,inter);
  input clk,reset,MemRd,MemWr;
  input[7:0] switch;
  input[31:0] Addr,WriteData;
  output reg[31:0] ReadData;
  output reg[3:0] AN;
  output reg[7:0] digital,led;
  output inter;

	reg[31:0] RAMDATA[255:0];
	reg[31:0] TH,TL;
	reg[2:0] TCON;
	
	initial 
	 begin
	  TH<=32'b1111_1111_1111_1111_1111_1111_0000_0000;
    TL<=32'b1111_1111_1111_1111_1111_1111_0000_0000;
    TCON<=3'b000;
	  led<=8'b0;
	  AN<=4'b1111;
	  digital<=8'b11111111;
	  ReadData<=32'b0;
	 end
	assign inter=TCON[2]; 

  always @(posedge clk,posedge reset) 
   begin
		if(reset)
		 begin 
		  TH<=32'b1111_1111_1111_1111_1111_1111_0000_0000;
      TL<=32'b1111_1111_1111_1111_1111_1111_0000_0000;
      TCON<=3'b000;
		 end
		else
		 begin
		  if((Addr[31:2]<256)&&MemWr) RAMDATA[Addr[31:2]]<=WriteData;
		  if((Addr==32'b0100_0000_0000_0000_0000_0000_0000_1100)&&MemWr) led<=WriteData[7:0];
		  if((Addr==32'b0100_0000_0000_0000_0000_0000_0001_0100)&&MemWr) begin AN<=~WriteData[11:8]; digital<=WriteData[7:0]; end
		                                                          
		  if((Addr==32'b0100_0000_0000_0000_0000_0000_0000_0000)&&MemWr) TH<=WriteData;
		  if((Addr==32'b0100_0000_0000_0000_0000_0000_0000_0100)&&MemWr) TL<=WriteData;
		  else if(TCON[0])
		    begin
		     if(TL==32'b1111_1111_1111_1111_1111_1111_1111_1111) TL<=TH;
			   else TL<=TL+32'b1;
		    end
		  if((Addr==32'b0100_0000_0000_0000_0000_0000_0000_1000)&&MemWr) TCON<=WriteData[2:0];
		  else if(TCON[1]&&TCON[0]&&(TL==32'b1111_1111_1111_1111_1111_1111_1111_1111)) TCON<=3'b111;
	   end
	 end

  always @(*)
   begin
    if(~MemRd) ReadData=32'b0;
    else
     begin
      casez(Addr)
       32'b0000_0000_0000_0000_0000_00??_????_??00: ReadData<=RAMDATA[Addr[31:2]];
       32'b0100_0000_0000_0000_0000_0000_0000_0000: ReadData<=TH;
       32'b0100_0000_0000_0000_0000_0000_0000_0100: ReadData<=TL;
       32'b0100_0000_0000_0000_0000_0000_0000_1000: ReadData<={29'b0,TCON};
       32'b0100_0000_0000_0000_0000_0000_0000_1100: ReadData<={24'b0,led};
       32'b0100_0000_0000_0000_0000_0000_0001_0000: ReadData<={24'b0,switch};
       32'b0100_0000_0000_0000_0000_0000_0001_0100: ReadData<={20'b0,~AN,digital};
       default: ReadData<=32'b0;
      endcase
     end
   end
endmodule    