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
// rev1.1
// 额外注释:
// 待定
////////////////////////////////////////////////////////////////////////////////
module asy_fifo #(
    parameter             DEPTH = 64  ,
    parameter             WIDTH = 32
) (
  //----------写控制端---------------
    input                   wr_clk      ,
    input                   wr_rst_n    ,
    input                   wr_en       ,
    output reg              fifo_full   ,
    input [WIDTH-1:0]       wr_data     ,

    //----------读控制段---------------
    input                   rd_clk      ,
    input                   rd_rst_n    ,
    input                   rd_en       ,
    output reg              fifo_empty  ,
    output [WIDTH-1:0]      rd_data     
);

localparam ADDR_WIDTH = $clog2(DEPTH);

// 读写指针，用于访存
reg [ADDR_WIDTH:0] wr_addr;
reg [ADDR_WIDTH:0] rd_addr;

// 延迟一拍和两拍的读写指针的格雷码
reg [ADDR_WIDTH:0] wr_addr_g_r, wr_addr_g_rr;
reg [ADDR_WIDTH:0] rd_addr_g_r, rd_addr_g_rr;

// 当前读写地址的格雷码
reg [ADDR_WIDTH:0] wr_addr_g;
reg [ADDR_WIDTH:0] rd_addr_g;

// 下一读写地址的格雷码
wire [ADDR_WIDTH:0] wr_addr_next_g;
wire [ADDR_WIDTH:0] rd_addr_next_g;

// 下一周期的写读地址
wire [ADDR_WIDTH:0] wr_addr_next, rd_addr_next;

// 双端口存储器的写使能和读使能
wire wen;
wire ren;

// 双端口存储器实例
dual_port_ram #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) U1(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .wr_data(wr_data),
    .wen(wen),
    .ren(ren),
    .rd_addr(rd_addr[ADDR_WIDTH-1:0]),
    .wr_addr(wr_addr[ADDR_WIDTH-1:0]),
    .rd_data(rd_data)
);

// 二进制码右移 1 位后与本身异或，其结果就是格雷码
assign wr_addr_next_g = wr_addr_next ^ (wr_addr_next >> 1);
assign rd_addr_next_g = rd_addr_next ^ (rd_addr_next >> 1);

// 下一读写地址的产生逻辑
assign wr_addr_next = wr_addr + (~fifo_full & wr_en);
assign rd_addr_next = rd_addr + (~fifo_empty & rd_en);

// 判断空满逻辑
// 1. 格雷码高两位相反，其余位相同为满
// 2. 格雷码全部位相同为空
// 3. 是与同步后的读写指针进行比较
// 此处是比较次态，用于下一次空满信号的产生
assign fifo_full_val = wr_addr_next_g == {~rd_addr_g_rr[ADDR_WIDTH:ADDR_WIDTH-1], rd_addr_g_rr[ADDR_WIDTH-2:0]};
assign fifo_empty_val = rd_addr_next_g == wr_addr_g_rr;

// 控制双端口存储器的读写
assign wen = wr_en & ~fifo_full;
assign ren = rd_en & ~fifo_empty;

// 空满信号的产生
always @(posedge wr_clk, negedge wr_rst_n) 
begin
    if (~wr_rst_n)
        fifo_full <= 1'b0;
    else
        fifo_full <= fifo_full_val;
end

always @(posedge rd_clk, negedge rd_rst_n) 
begin
    if (~rd_rst_n)
        fifo_empty <= 1'b1;
    else
        fifo_empty <= fifo_empty_val;
end

// 地址更新和格雷码更新
always @(posedge wr_clk, negedge wr_rst_n) 
begin
    if (~wr_rst_n)
        {wr_addr, wr_addr_g} <= 0;
    else  
        {wr_addr, wr_addr_g} <= {wr_addr_next, wr_addr_next_g};
end

always @(posedge rd_clk, negedge rd_rst_n) 
begin
    if (~rd_rst_n)
        {rd_addr, rd_addr_g} <= 0;
    else  
        {rd_addr, rd_addr_g} <= {rd_addr_next, rd_addr_next_g};
end

// 两拍延迟，用于时钟同步
always @(posedge rd_clk, negedge rd_rst_n)
begin
    if (~rd_rst_n)
        {wr_addr_g_rr, wr_addr_g_r} <= 0;
    else
        {wr_addr_g_rr, wr_addr_g_r} <= {wr_addr_g_r, wr_addr_g};
end

always @(posedge wr_clk, negedge wr_rst_n)
begin
    if (~wr_rst_n)
        {rd_addr_g_rr, rd_addr_g_r} <= 0;
    else
        {rd_addr_g_rr, rd_addr_g_r} <= {rd_addr_g_r, rd_addr_g};
end
endmodule