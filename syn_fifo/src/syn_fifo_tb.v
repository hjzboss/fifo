`timescale 1ns/1ps
////////////////////////////////////////////////////////////////////////////////
// 公司: NUDT
// 工程师: hjz
// 创建日期: 2022/11/13
// 设计名称: 同步fifo
// 模块名: syn_fifo_tb
// 目标器件: 未定
// 工具软件版本号: vivado
// 描述:
// 同步fifo的testbench
// 修订版本:
// rev1.0
// 额外注释:
// 待定
////////////////////////////////////////////////////////////////////////////////
module syn_fifo_tb;

reg clk, rst_n, we, re;
reg [31:0] wdata;
wire [31:0] rdata;
wire full, empty;

always #10 clk = ~clk;

initial begin
    clk <= 1'b0;
    rst_n <= 1'b0;
    we <= 1'b0;
    re <= 1'b0;
    #15
    rst_n <= 1'b1;
end

initial begin
    $dumpfile("wave_fifo.vcd"); // 指定用作dumpfile的文件
    $dumpvars; // dump all vars
end

initial begin
    #20
    wdata <= 31'd1;
    #30
    wdata <= 31'd2;
    $display("写入数据：%d\n", wdata);
    #20
    wdata <= 31'd3;
    $display("写入数据：%d\n", wdata);
    #20
    wdata <= 31'd4;
    $display("写入数据：%d\n", wdata);
    #20
    $display("写入数据：%d\n", wdata);
end

initial begin
    #40
    we <= 1'b1;
    #70
    we <= 1'b0;
end

initial begin
    #130
    re <= 1'b1;
end

initial begin
    #270
    $finish;
end

syn_fifo #(
    .DEPTH(4)
) fifo_inst(
    .clk(clk),
    .rst_n(rst_n),
    .wdata(wdata),
    .rdata(rdata),
    .we(we),
    .re(re),
    .full(full),
    .empty(empty)
);
endmodule