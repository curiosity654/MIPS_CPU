module CPU_Control(Instruct,PC,IRQ,JT,Imm16,Shamt,Rd,Rt,Rs,
                   PCSrc,RegDst,RegWr,ALUSrc1,ALUSrc2,ALUFun,
                   Sign,MemWr,MemRd,MemToReg,EXTOp,LUOp);
  
  input[31:0] Instruct;
  input PC,IRQ;  //PC[31]
  output[25:0] JT;
  output[15:0] Imm16;
  output[4:0] Shamt, Rd, Rt, Rs;
  output[2:0] PCSrc;
  output[1:0] RegDst, MemToReg;
  output[5:0] ALUFun;
  output RegWr,ALUSrc1,ALUSrc2,Sign,MemWr,MemRd,EXTOp,LUOp;
  wire[5:0] Op, Funct;
  wire R,I,J,JR,nop,true;
  wire ILLOP,XADR;
  wire branch_eq, branch_slt;

  //domain
  assign Op=Instruct[31:26];    //R_Type,I_Type,J_Type
  assign Rs=Instruct[25:21];    //R_Type,I_Type
  assign Rt=Instruct[20:16];    //R_Type,I_Type
  assign Rd=Instruct[15:11];    //R_Type
  assign Shamt=Instruct[10:6];  //R_Type
  assign Funct=Instruct[5:0];   //R_Type
  assign Imm16=Instruct[15:0];  //I_type
  assign JT=Instruct[25:0];     //J_Type
  
  assign R=(Instruct[31:26]==6'b000000)&~nop&((Instruct[10:3]==8'b00000100)| //add,addu,sub,subu,and,or,xor,nor 
         (Instruct[10:0]==11'b00000101010)|  //slt
				 ((Instruct[25:21]==5'b00000)&(Instruct[5:2]==4'b0000)&(Instruct[1:0]!=2'b01))| //sll,srl,sra
				 ((Instruct[20:11]==10'b00_0000_0000)&(Instruct[5:1]==5'b00100))| //jr
				 ((Instruct[20:16]==5'b00000)&(Instruct[5:0]==6'b001001)));  //jalr
  assign I=((Instruct[31:29]==3'b001)&((Instruct[28:26]==3'b100)|~Instruct[28]|(Instruct[28:21]==8'b11100000)))|  //addi,addiu,andi,lui,slti,sltiu
			     ((Instruct[31:30]==2'b10)&(Instruct[28:26]==3'b011))|  //lw,sw
			     ((Instruct[31:29]==3'b000)&((Instruct[28:27]==2'b10)|  //beq,bne
			      ((Instruct[20:16]==5'b00000)&((Instruct[28:27]==2'b11)|(Instruct[28:26]==3'b001)))));//blez,bgtz,bltz
	assign J=(Instruct[31:27]==5'b00001);  //j,jal
	assign JR=R&(Instruct[5:1]==5'b00100); //jr, jalr
	assign nop=(Instruct==32'b0);  //nop
	
  assign branch_eq=I&(Instruct[31:29]==3'b000);  //beq,bne,blez,bgtz,bltz
  assign branch_slt=(R&Instruct[3])|(I&~Instruct[31]&(Instruct[28:27]==2'b01));  //slt,slti,sltiu
  assign true=R|I|J|nop;      // 判断是否是指令集中已有指令
  assign ILLOP=~PC&IRQ;       // 是否发生中断
  assign XADR=~PC&~true;      // 是否发生异常
   
  //Instruct
  // PC产生的选择信号PCSrc, 取值0,1,2,3,4及其它，分别选择下一指令不同的PC
  assign PCSrc[0]=(JR|branch_eq|XADR)&~ILLOP;
  assign PCSrc[1]=(JR|J)&~ILLOP;
  assign PCSrc[2]=XADR|ILLOP;
  // 目的寄存器选择信号RegDst:00->R; 01->I; 10:J/JALR; 11->X;
  assign RegDst[0]=I|~true;
  assign RegDst[1]=(J&Op[0])|(JR&Funct[0])|~true;
  // 写寄存器使能信号RegWr: 1->允许对寄存器进行写操作
  assign RegWr=(R&~(JR&~Funct[0]))|(I&~branch_eq&~MemWr)|(J&Op[0])|XADR;
  // ALU第一个操作数选择信号ALUSrc1: 1->将移位量shamt进行0扩展后作为输入; 0->将Rs寄存器中的值作为输入
  assign ALUSrc1=R&~Funct[5]&~Funct[3];  //sll,srl,sra
  // ALU第一个操作数选择信号ALUSrc1: 1->将扩展后的32位立即数作为输入; 0->将Rt寄存器中的值作为输入
  assign ALUSrc2=I&~branch_eq;  
  // ALU运算控制信号ALUfun[5:4]: 00->adder; 01->logic; 10->shift; 11->compare;
  assign ALUFun[5]=(R&~Funct[5])|branch_eq|branch_slt; //shift,compare,j               
  assign ALUFun[4]=(R&Funct[2])|branch_eq|branch_slt|(Op[3:1]==3'b110); //logic,compare
  assign ALUFun[3]=(R&(Funct[2:1]==2'b10))|(branch_eq&Op[1])|(Op[3:1]==3'b110); //and,or,bgtz,blez,andi
  assign ALUFun[2]=(R&Funct[2]&(Funct[1]^Funct[0]))|((branch_eq|branch_slt)&(Op[2:1]!=2'b10));//or,xor,bgtz,blez,bltz,slt,slti,sltiu
  assign ALUFun[1]=(R&Funct[2]&(Funct[1]^Funct[0]))|(R&Funct[0]&~Funct[5])|(branch_eq&((Op[2:0]==3'b100)|(Op[2:0]==3'b111))); //or,xor,sra,jalr,beq,bgtz
  assign ALUFun[0]=(R&Funct[1]&(~Funct[2]|Funct[0]))|branch_eq|branch_slt; //sub,subi,nor,srl,sra,slt,
                                                                           //beq,bne,blez,bgtz,bltz,slt,slti,sltiu                               
  // 有无符号数指示信号Sign: 1->有符号数; 0->无符号数
  assign Sign=(R&(Funct[5:2]==4'b1000)&~Funct[0])|(I&(Op[5:2]==4'b0010)&~Op[0]); //and,sub,addi,slti
  assign MemRd=Op[5]&~Op[3]; //Op==6'b100011
  assign MemWr=Op[5]&Op[3];  //Op==6'b101011
  // 写寄存器值的选择信号MemToReg: 00->ALU; 01->Load; 10: jal,jalr,X;
  assign MemToReg[0]=MemRd;  
  assign MemToReg[1]=(J&Op[0])|(JR&Funct[0])|XADR; 
  // 符号位扩展指示信号EXTOp: 1->对16位立即数进行符号位扩展; 0->0扩展
  assign EXTOp=Sign;
  // 立即数高位取指令指示信号LUOp, 判断是否为lui指令
  assign LUOp=(Op[3:1]==3'b111); //lui
endmodule