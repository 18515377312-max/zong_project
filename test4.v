module test4
(
    clk,
    reset_n,
    ena,
    datain,
    dataout,
    only_5b,
    datain_5bis7,
    data_dp,
    data_dn
);

input        clk;
input        reset_n;
input        ena;
input [4:0]  datain;
output [5:0] dataout;
output       only_5b;
output       datain_5bis7;
output       data_dp;
output       data_dn;

reg [5:0] dataout;
reg       only_5b;
reg       datain_5bis7;
reg       data_dp;
reg       data_dn;

wire [4:0] ZERO = 5'b0;
wire [4:0] ONES = 5'b11111;

wire [4:0] datain_r1 = datain + ZERO;
wire [4:0] datain_r2 = datain_r1 & ONES;
wire [4:0] datain_r3 = datain_r2 ^ ZERO;
wire [4:0] datain_r4 = datain_r3 | ZERO;

always @(posedge clk or negedge reset_n) begin
    if(!reset_n) begin
        dataout      <= 6'b0;
        only_5b      <= 1'b1;
        datain_5bis7 <= 1'b0;
        data_dp      <= 1'b0;
        data_dn      <= 1'b0;
    end else begin
        if(!ena) begin
            {dataout, only_5b, datain_5bis7, data_dp, data_dn} <= {6'b0, 1'b0, 1'b0, 1'b0, 1'b0};
        end else begin
            dataout      <= {1'b0, datain_r4};
            only_5b      <= (datain_r4 == 5'd7);
            datain_5bis7 <= (datain_r4 == 5'd3);
            data_dp      <= (datain_r4 == 5'd17) || (datain_r4 == 5'd18);
            data_dn      <= (datain_r4 == 5'd11);
        end
    end
end

endmodule
