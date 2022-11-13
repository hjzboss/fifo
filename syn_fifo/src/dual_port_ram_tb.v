`timescale 1ns/1ps
////////////////////////////////////////////////////////////////////////////////
// 公司: NUDT
// 工程师: hjz
// 创建日期: 2022/11/13
// 设计名称: 同步fifo
// 模块名: dual_port_ram_tb
// 目标器件: 未定
// 工具软件版本号: vivado
// 描述:
// 双端口ram的testbench
// 修订版本:
// rev1.0
// 额外注释:
// 待定
////////////////////////////////////////////////////////////////////////////////
module dual_port_ram_tb;

reg clk, rst_n;
reg [5:0] waddr, raddr;
reg [31:0] wdata;
wire [31:0] rdata;
reg we, re;

always #10 clk = ~clk;

initial begin
    $dumpfile("wave_ram.vcd"); // 指定用作dumpfile的文件
    $dumpvars; // dump all vars
end

initial begin
    clk <= 1'b0;
    rst_n <= 1'b0;
    we <= 1'b0;
    re <= 1'b0;
    #20
    rst_n <= 1'b1;
    #5
    waddr <= 6'd60;
    raddr <= 6'd60;
    wdata <= 32'd15;
    #15
    we <= 1'b1;
    #20
    we <= 1'b0;
    #10
    re <= 1'b1;
    wdata <= 32'd32;
    #20
    re <= 1'b0;
    #40
    $display("%d", rdata);
    $finish;
end

dual_port_ram ram_inst(
    .wclk(clk),
    .rclk(clk),
    .wdata(wdata),
    .we(we),
    .re(re),
    .raddr(raddr),
    .waddr(waddr),
    .rdata(rdata)
);
endmodule