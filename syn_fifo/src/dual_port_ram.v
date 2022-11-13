module dual_port_ram #(
    parameter DEPTH = 64,
    parameter WIDTH = 32
) (
    input wclk,
    input rclk,
    input [WIDTH-1:0] wdata,
    input we, // 写使能信号
    input re, // 读使能信号
    input [$clog2(DEPTH)-1:0] raddr, // 写指针
    input [$clog2(DEPTH)-1:0] waddr, // 读指针
    output reg [WIDTH-1:0] rdata
);

reg [DEPTH-1:0] mem [WIDTH-1:0];

always @(posedge wclk) begin
    if (we)
        mem[waddr] <= wdata;
end

always @(posedge rclk) begin
    if (re)
        rdata <= mem[raddr];
end
endmodule