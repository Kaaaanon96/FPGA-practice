module CLOCK24 (
  input CLK, RST,
  input   [2:0] KEY,
  output  [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5
);


wire en1hz, sig2hz;
CNT1SEC cnt1sec(
  .CLK  (CLK),
  .RST  (RST),
  .EN1HZ(en1hz),
  .SIG2HZ(sig2hz)
);

wire mode, select, adjust;
BTN_IN  btn_in(
  .CLK  (CLK),
  .RST  (RST),
  .nBIN (KEY),
  .BOUT ({ mode, select, adjust})
);

wire  secon,  minon,  houron;
wire  secclr, mininc, hourinc;
STATE state(
  .CLK    (CLK),
  .RST    (RST),
  .SIG2HZ (sig2hz),
  .MODE   (mode),
  .SELECT (select),
  .ADJUST (adjust),
  .SECON  (secon),
  .MINON  (minon),
  .HOURON (houron),
  .SECCLR (secclr),
  .MININC (mininc),
  .HOURINC(hourinc)
);

wire  [3:0] secL, minL, hourL;
wire  [2:0] secH, minH;
wire  [1:0] hourH;
wire  csec, cmin;

SECCNT  sec(
  .CLK  (CLK),
  .RST  (RST),
  .EN   (en1hz),
  .CLR  (secclr),
  .QL   (secL),
  .QH   (secH),
  .CA   (csec)
);

MINCNT  min(
  .CLK  (CLK),
  .RST  (RST),
  .EN   (csec),
  .INC  (mininc),
  .QL   (minL),
  .QH   (minH),
  .CA   (cmin)
);

HOURCNT hour(
  .CLK  (CLK),
  .RST  (RST),
  .EN   (cmin),
  .INC  (hourinc),
  .QL   (hourL),
  .QH   (hourH)
);

SEG7DEC d0( .DIN(secL),   .EN(secon),   .nHEX(HEX0) );
SEG7DEC d1( .DIN(secH),   .EN(secon),   .nHEX(HEX1) );
SEG7DEC d2( .DIN(minL),   .EN(minon),   .nHEX(HEX2) );
SEG7DEC d3( .DIN(minH),   .EN(minon),   .nHEX(HEX3) );
SEG7DEC d4( .DIN(hourL),  .EN(houron),  .nHEX(HEX4) );
SEG7DEC d5( .DIN(hourH),  .EN(houron),  .nHEX(HEX5) );

endmodule
