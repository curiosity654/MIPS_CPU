module CPU_single_cycle(clk,reset,switch,led,AN,digital);
  input clk,reset;
  input[7:0] switch;  // 开关输入
  output[3:0] AN;     // 暂时没理解
  output[7:0] digital,led;
  wire IRQ,RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
  wire[1:0] RegDst,MemToReg;
  wire[2:0] PCSrc;
  wire[4:0] Shamt,Rd,Rt,Rs,AddrC;
  wire[5:0] ALUFun;
  wire[15:0] Imm16;
	wire[25:0] JT;
	wire[31:0] PC_plus,ConBA,DataBusA,DataBusB,DataBusC,Imm32,Imm,A,B,ALUOut,ReadData,Instruct,PC;

  CPU_PC cpuPC(clk,PCSrc,ALUOut[0],JT,ConBA,DataBusA,reset,PC);
  // 指令存储器
  CPU_Instruction_Memorg Instruction_Memorg(.reset(reset),.PC({PC[31],PC[8:2]}),.Instruct(Instruct));
  // 控制器，细节待理解
  CPU_Control Control(Instruct,PC[31],IRQ,JT,Imm16,Shamt,Rd,Rt,Rs,
                      PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,
                      Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);
  // MUX的输出目前认为是控制写入寄存器地址，输入是Rd/Rt/另外两个地址待理解，输出到寄存器堆的AddrC端口
  mux4_1 m1(.c0(Rd),.c1(Rt),.c2(5'b11111),.c3(5'b11010),.s(RegDst),.y(AddrC));
  // 寄存器堆，两个读地址端口连接Rs/Rt, IRQ表明是否有中断请求
  CPU_Registers Registers(clk,reset,Rs,Rt,AddrC,RegWr,DataBusC,PC,IRQ,DataBusA,DataBusB);
  // 扩展器, 根据EXTOp进行零扩展或符号扩展
  CPU_Extender Extender(Imm16,EXTOp,Imm32);
  // 用于处理LUI指令, load半字
  mux2_1 m2(.a(Imm32),.b({Imm16,16'b0}),.s(LUOp),.y(Imm));
  // 下面两个MUX用于选择ALU的操作数，可能来自寄存器堆，或移位数量，或立即数
  mux2_1 m3(.a(DataBusA),.b({27'b0,Shamt}),.s(ALUSrc1),.y(A));
  mux2_1 m4(.a(DataBusB),.b(Imm),.s(ALUSrc2),.y(B));
  // ALU, Sign是判断有无符号, ALUfun[0]是判定加减法
  ALU cpuALU(A,B,ALUFun,Sign,ALUOut);
  // PC_plus是默认的下一个PC地址? ConBA应该是可能跳转到的PC地址
  assign PC_plus={PC[31],{PC[30:0]+31'b000_0000_0000_0000_0000_0000_0000_0100}};
  assign ConBA={PC[31],PC_plus[30:0]+{Imm32[28:0],2'b00}};
  CPU_RAM RAM(clk,reset,switch,ALUOut,DataBusB,MemRd,MemWr,ReadData,led,AN,digital,IRQ);
	mux4_1 m5(.c0(ALUOut),.c1(ReadData),.c2(PC_plus),.c3(32'b0),.s(MemToReg),.y(DataBusC));
endmodule