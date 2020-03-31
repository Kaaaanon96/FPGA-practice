module SEC60(
	input		CLK, RST,
	output	[6:0]	HEX0,
	output	[6:0] HEX1
);

// 1Hzのイネーブル信号を生成
// CLK ( 50MHz )
// CLK -> 50M count -> 1second
// 50,000,000 -> b10_1111_1010_1111_0000_1000_0000(26bit)
// en1hz -> Flag every seconds
reg[25:0] cnt;
wire en1hz = (cnt==26'd49_999_999);

// RST in -> cnt 0
// 1 second pass -> cnt 0
// other than that
always @( posedge CLK ) begin
	if ( RST )
		cnt <= 26'b0;
	else if ( en1hz )
		cnt <= 26'b0;
	else 
		cnt <= cnt + 26'b1;
end

/* ten count(seond) */
reg [3:0] sec;

always @( posedge CLK ) begin
	if ( RST )
		sec <= 4'h0;
	else if ( en1hz )
		if ( sec==4'h9 ) begin
			sec <= 4'h0;
			end
		else
			sec <= sec + 4'h1;
end

/* six count key second ( minutes ) */
reg [2:0] min;

always @( posedge CLK ) begin
	if ( RST )
		min <= 3'h0;
	else if ( sec==4'h9 && en1hz )
		if ( min == 3'h5 )
			min <= 3'h0;
		else
			min <= min + 3'h1;

end

seg7dec dec_sec(sec, HEX0);
seg7dec dec_min(min, HEX1);

endmodule