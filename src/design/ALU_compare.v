module ALU_compare(zero,neg,ALUfun,S);
    input zero,neg;
    input[2:0] ALUfun; //ALUfun[3:1]:
                       //EQ->001; NEQ->000; LT->010; LEZ->110; GEZ->100; GTZ->111;
    output[31:0] S; 
    wire[31:0] EQ,NEQ,LT,LEZ,GEZ,GTZ;
    wire[31:0] logic1,logic2;
    assign EQ=(zero==1'b1)? 1:0;
    assign NEQ=(zero==1'b1)? 0:1;
    assign LT=(neg==1'b1)? 1:0;
    assign LEZ=(neg==1'b1 || zero==1'b1)? 1:0;
    assign GEZ=(neg==1'b1)? 0:1;
    assign GTZ=(neg==1'b0 && zero==1'b0)? 1:0;    
    mux4_1 m1(.c0(NEQ),.c1(EQ),.c2(LT),.c3(0),.s(ALUfun[1:0]),.y(logic1));
    mux4_1 m2(.c0(GEZ),.c1(0),.c2(LEZ),.c3(GTZ),.s(ALUfun[1:0]),.y(logic2));  
    mux2_1 m3(.a(logic1),.b(logic2),.s(ALUfun[2]),.y(S)); 
endmodule