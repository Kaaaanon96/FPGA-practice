module CNT1SEC(
	input CLK, RST,
	output EN1HZ
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

endmodule
