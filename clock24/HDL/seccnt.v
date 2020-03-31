module SECCNT (
  input CLK, RST,
  input EN, CLR,
  output  reg [3:0] QL,
  output  reg [2:0] QH,
  output  CA
);

// Low
always @( posedge CLK ) begin
  if( RST | CLR )
    QL <= 4'h0;
  else if( EN )
    if( QL==4'h9 )
      QL <= 4'h0;
    else
      QL <= QL + 4'h1;
end

// High
always @( posedge CLK ) begin
  if( RST | CLR )
    QH <= 3'h0;
  else if( QL==4'h9 && EN )
    if( QH==3'h5 )
      QH <= 3'h0;
    else
      QH <= QH + 3'h1;
end

assign CA = ( QL==4'h9 && QH==3'h5 && EN );

endmodule
