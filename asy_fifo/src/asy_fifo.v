////////////////////////////////////////////////////////////////////////////////
// 公司: NUDT
// 工程师: hjz
// 创建日期: 2022/11/14
// 设计名称: 异步fifo
// 模块名: asy_fifo
// 目标器件: 未定
// 工具软件版本号: vivado
// 描述:
// 同步fifo主模块
// 修订版本:
// rev1.0
// 额外注释:
// 待定
////////////////////////////////////////////////////////////////////////////////
module asy_fifo #(
    parameter             DEPTH = 64  ,
    parameter             WIDTH = 32
) (
  //----------写控制端---------------
    input                 wr_clk      ,
    input                 wr_rst_n    ,
    input                 wr_en       ,
    output                fifo_full   ,
    input [WIDTH-1:0]     wr_data     ,

    //----------读控制段---------------
    input                 rd_clk      ,
    input                 rd_rst_n    ,
    input                 rd_en       ,
    output                fifo_empty  ,
    output [WIDTH-1:0]    rd_data     
);

localparam ADDR_WIDTH = $clog2(DEPTH);

// 读写指针
reg [ADDR_WIDTH:0] wr_addr;
reg [ADDR_WIDTH:0] rd_addr;

// 延迟一拍和两拍的读写指针
reg [ADDR_WIDTH:0] wr_addr_g_r, wr_addr_g_rr;
reg [ADDR_WIDTH:0] rd_addr_g_r, rd_addr_g_rr;

// 读写地址的格雷码
wire [ADDR_WIDTH:0] wr_addr_g;
wire [ADDR_WIDTH:0] rd_addr_g;

// 双端口存储器的写使能和读使能
wire wen;
wire ren;

// 双端口存储器
dual_port_ram U1 #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) (
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .wr_data(wr_data),
    .wen(wen),
    .ren(ren),

);

// 二进制码右移 1 位后与本身异或，其结果就是格雷码
assign wr_addr_g = wr_addr ^ (wr_addr >> 1);
assign rd_addr_g = rd_addr ^ (rd_addr >> 1);

// 判断空满逻辑
// 1. 格雷码高两位相反，其余位相同为满
// 2. 格雷码全部位相同为空
assign fifo_full = (wr_addr_g == {~rd_addr_g_rr[ADDR_WIDTH:ADDR_WIDTH-1], rd_addr_g_rr[ADDR_WIDTH-2:0]}) & wr_rst_n;
assign fifo_empty = (rd_addr_g == wr_addr_g_rr) & rd_rst_n;

// todo:地址读写
always @(posedge wr_clk, negedge wr_rst_n) 
begin
    
end

//todo:两拍延迟
endmodule