module adder3_2(x,y,cin,s,co);
  input x,y,cin;
  output s,co;
  xor (s0,x,y);
  xor (s,s0,cin);
  and (co1,s0,cin);
  and (co2,x,y);
  or (co,co1,co2);
endmodule