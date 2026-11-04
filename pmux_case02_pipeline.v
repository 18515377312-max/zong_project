
module pmux_case02_pipeline #(
    parameter integer LANES = 1,
    parameter integer WIDTH = 3
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire [LANES*4*WIDTH-1:0] data_in,
    input wire [LANES*16-1:0] ctrl_in,
    output wire [LANES*WIDTH-1:0] data_out
);

    genvar i;
    generate for (i = 0; i < LANES; i = i + 1) begin: lane
        wire [WIDTH-1:0] a = (((((data_in[i*4*WIDTH +: WIDTH]) + 3'b000) + 3'b000) + 3'b000) + 3'b000) + 3'b000;
        wire [WIDTH-1:0] b = (((((data_in[i*4*WIDTH+WIDTH +: WIDTH]) & 3'b111) & 3'b111) & 3'b111) & 3'b111) & 3'b111;
        wire [WIDTH-1:0] c = (((((data_in[i*4*WIDTH+2*WIDTH +: WIDTH]) ^ 3'b000) ^ 3'b000) ^ 3'b000) ^ 3'b000) ^ 3'b000;
        wire [WIDTH-1:0] d = (((((data_in[i*4*WIDTH+3*WIDTH +: WIDTH]) | 3'b000) | 3'b000) | 3'b000) | 3'b000) | 3'b000;
        wire [15:0] s = ctrl_in[i*16 +: 16];
        reg [WIDTH-1:0] q;
        assign data_out[i*WIDTH +: WIDTH] = q;
        reg [WIDTH-1:0] x0, x1, x2, x3, next_q;

        wire [WIDTH-1:0] ZERO = {WIDTH{1'b0}};
        wire [WIDTH-1:0] ONES = {WIDTH{1'b1}};
        wire [WIDTH-1:0] ax_q = a ^ q;
        wire [WIDTH-1:0] bx_q = b ^ q;
        wire [WIDTH-1:0] cx_q = c ^ q;
        wire [WIDTH-1:0] dx_q = d ^ q;

        always @* begin
            case (s[1:0])
                2'd0: x0 = (ax_q) + ZERO;
                2'd1: x0 = (b + q) & ONES;
                2'd2: x0 = (c - q) ^ ZERO;
                default: x0 = (d) | ZERO;
            endcase
        end
        always @* begin
            case (s[3:2])
                2'd0: x1 = (bx_q) + ZERO;
                2'd1: x1 = (c + a) & ONES;
                2'd2: x1 = (d - b) ^ ZERO;
                default: x1 = (a) | ZERO;
            endcase
        end
        always @* begin
            case (s[5:4])
                2'd0: x2 = (cx_q) + ZERO;
                2'd1: x2 = (d + b) & ONES;
                2'd2: x2 = (a - c) ^ ZERO;
                default: x2 = (b) | ZERO;
            endcase
        end
        always @* begin
            case (s[7:6])
                2'd0: x3 = (dx_q) + ZERO;
                2'd1: x3 = (a + c) & ONES;
                2'd2: x3 = (b - d) ^ ZERO;
                default: x3 = (c) | ZERO;
            endcase
        end
        always @* begin
            case (s[9:8])
                2'd0: next_q = (x0) + ZERO;
                2'd1: next_q = (x1) & ONES;
                2'd2: next_q = (x2) ^ ZERO;
                default: next_q = (x3) | ZERO;
            endcase
        end
        always @(posedge clk) begin
            if (rst) q <= {WIDTH{1'b0}};
            else if (en) q <= next_q;
        end
    end endgenerate
endmodule
