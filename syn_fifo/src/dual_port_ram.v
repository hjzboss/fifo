////////////////////////////////////////////////////////////////////////////////
// 公司: NUDT
// 工程师: hjz
// 创建日期: 2022/11/13
// 设计名称: 同步fifo
// 模块名: dual_port_ram
// 目标器件: 未定
// 工具软件版本号: vivado
// 描述:
// 双端口ram
// 修订版本:
// rev1.0
// 额外注释:
// 待定
////////////////////////////////////////////////////////////////////////////////
module dual_port_ram #(
    parameter DEPTH = 64,
    parameter WIDTH = 32
) (
    input wclk,
    input rclk,
    input [WIDTH-1:0] wdata, // 写数据
    input we, // 写使能信号
    input re, // 读使能信号
    input [$clog2(DEPTH)-1:0] raddr, // 写指针
    input [$clog2(DEPTH)-1:0] waddr, // 读指针
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] mem [0:DEPTH-1]; // 存储器的定义

always @(posedge wclk) begin
    if (we)
        mem[waddr] <= wdata;
end

always @(posedge rclk) begin
    if (re)
        rdata <= mem[raddr];
end
endmodule