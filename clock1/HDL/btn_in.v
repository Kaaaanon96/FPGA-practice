module BTN_IN (
	input CLK, RST,
	input       [2:0] nBIN,
	output reg	[2:0]	BOUT
);

// 40Hzの信号を生成
reg [20:0]  cnt;
wire en40hz = (cnt==21'd1_249_999);

always @( posedge CLK ) begin
  if( RST )
    cnt <= 21'b0;
  else if( en40hz )
    cnt <= 21'b0;
  else
    cnt <= cnt + 21'b1;
end

// FFを2個宣言
// 繋げることで処理を遅延させる
reg [2:0] ff1, ff2;

always @( posedge CLK ) begin
  if( RST ) begin
    ff2 <= 3'b0;
    ff1 <= 3'b0;
  end
  else if( en40hz ) begin
    ff2 <= ff1;
    ff1 <= nBIN;
  end
end

// ~ff1とff2とen40Hzのアンドを取る。
// en40hzは1bitなので3bitに拡張しておく
wire [2:0] temp = ~ff1 & ff2 & {3{en40hz}};

// 最後にもう一度FFにかませて出力
always @( posedge CLK ) begin
  if( RST )
    BOUT <= 3'b0;
  else
    BOUT <= temp;
end

endmodule
