module shift_16(B,enable,ALUfun,y);
    input[31:0] B;
    input enable;
    input[1:0] ALUfun; //ALUfun[1:0] 00->SLL; 01->SRL; 11->SRA
    output[31:0] y;
    wire[31:0] logic1,logic2,logic3;
    mux2_1 m1(.a({B[15:0],16'b0000_0000_0000_0000}),.b({16'b0000_0000_0000_0000,B[31:16]}),.s(ALUfun[0]),.y(logic1));
    mux2_1 m2(.a({16'b0000_0000_0000_0000,B[31:16]}),.b({16'b1111_1111_1111_1111,B[31:16]}),.s(B[31]),.y(logic2));
    mux2_1 m3(.a(logic1),.b(logic2),.s(ALUfun[1]),.y(logic3));
    mux2_1 m4(.a(B),.b(logic3),.s(enable),.y(y));
endmodule
