module CNT1SEC(
	input CLK, RST,
	output     EN1HZ,
  output reg SIG2HZ
);

reg[25:0] cnt;

always @( posedge CLK ) begin
  if( RST )
    cnt <= 26'b0;
  else if( EN1HZ )
    cnt <= 26'b0;
  else
    cnt <= cnt + 26'b1;
end

// EN1HZ = 1bit wire
assign EN1HZ = (cnt==26'd49_999_999);

// 2Hzの信号を作るために4Hzの周期で出力を反転
wire one_quarters   = ( cnt==26'd12_499_999);
wire two_quarters   = ( cnt==26'd24_999_999);
wire three_quarters = ( cnt==26'd37_499_999);

always @( posedge CLK ) begin
  if( RST )
    SIG2HZ <= 1'b0;
  else if( one_quarters | two_quarters | three_quarters | EN1HZ )
    SIG2HZ <= ~SIG2HZ;
end

endmodule
