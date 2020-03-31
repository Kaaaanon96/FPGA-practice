module CLOCK1 (
  input   CLK, RST,
  input   [2:0] KEY,
  output  [6:0] HEX0, HEX1, HEX2, HEX3
);

wire  clr, minup, secup;
BTN_IN btn_in(
  .CLK  (CLK),
  .RST  (RST),
  .nBIN (KEY),
  .BOUT ({clr, minup, secup})
);

wire en1hz;
CNT1SEC cnt1sec( 
  .CLK  (CLK), 
  .RST  (RST), 
  .EN1HZ(en1hz)
);

wire  [3:0]   min1,  sec1;
wire  [2:0]   min10, sec10;
wire  cout;

CNT60 sec( 
  .CLK(CLK), 
  .RST(RST), 
  .EN(en1hz),
  .INC(secup),
  .CLR(clr),
  .HS(sec10), 
  .LS(sec1), 
  .CA(cout)
);

CNT60 min( 
  .CLK(CLK), 
  .RST(RST),
  .EN(cout),
  .INC(minup),
  .CLR(clr),
  .HS(min10), 
  .LS(min1), 
  .CA()
);

SEG7DEC d0( .DIN(sec1),  .nHEX(HEX0) );
SEG7DEC d1( .DIN(sec10), .nHEX(HEX1) );
SEG7DEC d2( .DIN(min1),  .nHEX(HEX2) );
SEG7DEC d3( .DIN(min10), .nHEX(HEX3) );

endmodule
