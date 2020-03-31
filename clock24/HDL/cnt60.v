module CNT60 (
  input CLK, RST,
  input EN, INC, CLR,
  output  reg [3:0] LS,
  output  reg [2:0] HS,
  output  CA
);

// Low
always @( posedge CLK ) begin
  if( RST | CLR )
    LS <= 4'h0;
  else if( EN == 1'b1 | INC == 1'b1 )
    if( LS==4'h9 )
      LS <= 4'h0;
    else
      LS <= LS + 4'h1;
end

// Hight
always @( posedge CLK ) begin
  if( RST | CLR )
    HS <= 3'h0;
  else if( LS==4'h9 && ( EN == 1'b1 | INC == 1'b1) )
    if( HS==3'h5 )
      HS <= 3'h0;
    else
      HS <= HS + 3'h1;
end

assign CA = ( HS==3'h5 && LS == 4'h9 && EN == 1'b1 );


endmodule
