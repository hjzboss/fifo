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
    output reg full,
    output reg empty
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
        full <= 1'b0;
    else if (raddr == {~waddr[DEPTHPLUS], waddr[DEPTHPLUS-1:0]})
        full <= 1'b1;
    else
        full <= 1'b0;
end

always @(posedge clk, negedge rst_n) begin
    if (~rst_n)
        empty <= 1'b0;
    else if (raddr == waddr)
        empty <= 1'b1;
    else
        empty <= 1'b0;
end

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
endmodule