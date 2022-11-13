////////////////////////////////////////////////////////////////////////////////
// 公司: NUDT
// 工程师: hjz
// 创建日期: 2022/11/13
// 设计名称: 同步fifo
// 模块名: syn_fifo
// 目标器件: 未定
// 工具软件版本号: vivado
// 描述:
// 同步fifo主模块
// 修订版本:
// rev1.0
// 额外注释:
// 待定
////////////////////////////////////////////////////////////////////////////////
module syn_fifo #(
    parameter DEPTH = 64,
    parameter WIDTH = 32
) (
    input clk,
    input rst_n,
    input [WIDTH-1:0] wdata,
    input we,
    input re,
    output [WIDTH-1:0] rdata,
    output full,
    output empty
);

localparam DEPTHPLUS = $clog2(DEPTH);

// 用额外的一位来判断是空还是满
reg [DEPTHPLUS:0] waddr, raddr;

dual_port_ram #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) ram(
    .wclk(clk),
    .rclk(clk),
    .waddr(waddr[DEPTHPLUS-1:0]),
    .raddr(raddr[DEPTHPLUS-1:0]),
    .we(we),
    .re(re),
    .rdata(rdata),
    .wdata(wdata)
);

always @(posedge clk, negedge rst_n) begin
    if (~rst_n)
        waddr <= 0;
    else if (we && ~full)
        waddr <= waddr + 1;
    else
        waddr <= waddr;
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n)
        raddr <= 0;
    else if (re && ~empty)
        raddr <= raddr + 1;
    else
        raddr <= raddr;
end

assign full = (rst_n && (raddr == {~waddr[DEPTHPLUS], waddr[DEPTHPLUS-1:0]})) ? 1'b1 : 1'b0;
assign empty = (rst_n && (raddr == waddr)) ? 1'b1 : 1'b0;
endmodule