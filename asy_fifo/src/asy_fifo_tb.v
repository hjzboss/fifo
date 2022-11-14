////////////////////////////////////////////////////////////////////////////////
// 公司: NUDT
// 工程师: hjz
// 创建日期: 2022/11/14
// 设计名称: 异步fifo的testbench
// 模块名: asy_fifo_tb
// 目标器件: 未定
// 工具软件版本号: vivado
// 描述:
// 同步fifo主模块
// 修订版本:
// rev1.0
// 额外注释:
// 待定
////////////////////////////////////////////////////////////////////////////////
module asy_fifo_tb;

parameter   width = 8;
parameter   depth = 8;

reg wr_clk, wr_en, wr_rst_n;
reg rd_clk, rd_en, rd_rst_n;

reg [width - 1 : 0] wr_data;

wire fifo_full, fifo_empty;

wire [width - 1 : 0] rd_data;

//实例化
asy_fifo #(
    .DEPTH(depth),
    .WIDTH(width)
) myfifo(
    .wr_clk(wr_clk),
    .rd_clk(rd_clk),
    .wr_rst_n(wr_rst_n),
    .rd_rst_n(rd_rst_n),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .wr_data(wr_data),
    .rd_data(rd_data),
    .fifo_empty(fifo_empty),
    .fifo_full(fifo_full)
);

//时钟
initial begin
    rd_clk = 0;
    forever #25 rd_clk = ~rd_clk;
end

initial begin
    wr_clk = 0;
    forever #30 wr_clk = ~wr_clk;
end

//波形显示
initial begin
    $dumpfile("asy_fifo_wave.vcd");        //生成的vcd文件名称
    $dumpvars(0, asy_fifo_tb);    //tb模块名称
end

//赋值
initial begin
    wr_en = 0;
    rd_en = 0;
    wr_rst_n = 1;
    rd_rst_n = 1;

    #10;
    wr_rst_n = 0;
    rd_rst_n = 0;

    #20;
    wr_rst_n = 1;
    rd_rst_n = 1;

    @(negedge wr_clk)
    wr_data = {$random} % 30;
    wr_en = 1;

    repeat(7) begin
        @(negedge wr_clk)
        wr_data = {$random} % 30;
    end

    @(negedge wr_clk)
    wr_en = 0;

    @(negedge rd_clk)
    rd_en = 1;

    repeat(7) begin
        @(negedge rd_clk);
    end

    @(negedge rd_clk)
    rd_en = 0;

    #150;

    @(negedge wr_clk)
    wr_en = 1;
    wr_data = {$random} % 30;

    repeat(15) begin
        @(negedge wr_clk)
        wr_data = {$random} % 30;
    end

    @(negedge wr_clk)
    wr_en = 0;

    #50;
    $finish;
end
endmodule