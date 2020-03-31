module STATE (
  input CLK, RST,
  input SIG2HZ,
  input MODE, SELECT, ADJUST,
  output  SECON, MINON, HOURON,
  output  SECCLR, MININC, HOURINC
);

// 今の状態と次の状態を記録
// 数値と文字列をひもづけてわかりやすく
reg [1:0] cur, next;
localparam NORM=2'b00, SEC=2'b01, MIN=2'b10, HOUR=2'b11;

// 出力
// 修正桁点滅
assign SECON   = ~((cur==SEC)  && SIG2HZ);
assign MINON   = ~((cur==MIN)  && SIG2HZ);
assign HOURON  = ~((cur==HOUR) && SIG2HZ);

// 修正時刻
assign SECCLR   = (cur==SEC)  && ADJUST;
assign MININC   = (cur==MIN)  && ADJUST;
assign HOURINC  = (cur==HOUR) && ADJUST;


// ステート生成
always @* begin
  case ( cur )
    NORM:   if( MODE )
              next <= SEC;
            else
              next <= NORM;
    SEC:    if( MODE )
              next <= NORM;
            else if( SELECT )
              next <= MIN;
            else
              next <= SEC;
    MIN:    if( MODE )
              next <= NORM;
            else if( SELECT )
              next <= HOUR;
            else
              next <= MIN;
    HOUR:    if( MODE )
              next <= NORM;
            else if( SELECT )
              next <= SEC;
            else
              next <= HOUR;
    default:next <= NORM;
  endcase
end

// レジスタ
always @( posedge CLK ) begin
  if ( RST )
    cur <= NORM;
  else
    cur <= next;
end

endmodule
