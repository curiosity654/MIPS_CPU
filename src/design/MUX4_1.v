module mux4_1(c0,c1,c2,c3,s,y);
  input[31:0] c0,c1,c2,c3;
  input[1:0] s;
  output[31:0] y;
  wire[31:0] logic1,logic2;
  mux2_1 m1(c0,c1,s[0],logic1); 
  mux2_1 m2(c2,c3,s[0],logic2);
  mux2_1 m3(logic1,logic2,s[1],y);   
endmodule