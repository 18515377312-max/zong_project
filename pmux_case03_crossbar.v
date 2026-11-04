
module pmux_case03_crossbar #(
    parameter integer LANES = 2,
    parameter integer WIDTH = 5
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
        wire [WIDTH-1:0] a = data_in[i*4*WIDTH +: WIDTH];
        wire [WIDTH-1:0] b = data_in[i*4*WIDTH+WIDTH +: WIDTH];
        wire [WIDTH-1:0] c = data_in[i*4*WIDTH+2*WIDTH +: WIDTH];
        wire [WIDTH-1:0] d = data_in[i*4*WIDTH+3*WIDTH +: WIDTH];
        wire [15:0] s = ctrl_in[i*16 +: 16];
        reg [WIDTH-1:0] q;
        assign data_out[i*WIDTH +: WIDTH] = q;
        reg [WIDTH-1:0] x0, x1, x2, x3, next_q;

        wire [WIDTH-1:0] ZERO = {WIDTH{1'b0}};
        wire [WIDTH-1:0] ONES = {WIDTH{1'b1}};

        wire [WIDTH-1:0] a_r1 = a + ZERO;
        wire [WIDTH-1:0] a_r2 = a_r1 & ONES;
        wire [WIDTH-1:0] a_r3 = a_r2 ^ ZERO;
        wire [WIDTH-1:0] a_r4 = a_r3 | ZERO;

        wire [WIDTH-1:0] b_r1 = b + ZERO;
        wire [WIDTH-1:0] b_r2 = b_r1 & ONES;
        wire [WIDTH-1:0] b_r3 = b_r2 ^ ZERO;
        wire [WIDTH-1:0] b_r4 = b_r3 | ZERO;

        wire [WIDTH-1:0] c_r1 = c + ZERO;
        wire [WIDTH-1:0] c_r2 = c_r1 & ONES;
        wire [WIDTH-1:0] c_r3 = c_r2 ^ ZERO;
        wire [WIDTH-1:0] c_r4 = c_r3 | ZERO;

        wire [WIDTH-1:0] d_r1 = d + ZERO;
        wire [WIDTH-1:0] d_r2 = d_r1 & ONES;
        wire [WIDTH-1:0] d_r3 = d_r2 ^ ZERO;
        wire [WIDTH-1:0] d_r4 = d_r3 | ZERO;

        wire [WIDTH-1:0] ab = a_r4 + b_r4;
        wire [WIDTH-1:0] bc = b_r4 + c_r4;
        wire [WIDTH-1:0] cd = c_r4 + d_r4;
        wire [WIDTH-1:0] da = d_r4 + a_r4;

        always @* begin
            case (s[1:0])
                2'd0: x0 = (a_r4) + ZERO;
                2'd1: x0 = (b_r4) & ONES;
                2'd2: x0 = (c_r4) ^ ZERO;
                default: x0 = (d_r4) | ZERO;
            endcase
        end
        always @* begin
            case (s[3:2])
                2'd0: x1 = (a_r4 ^ q) + ZERO;
                2'd1: x1 = (b_r4 ^ q) & ONES;
                2'd2: x1 = (c_r4 ^ q) ^ ZERO;
                default: x1 = (d_r4 ^ q) | ZERO;
            endcase
        end
        always @* begin
            case (s[5:4])
                2'd0: x2 = (ab) + ZERO;
                2'd1: x2 = (bc) & ONES;
                2'd2: x2 = (cd) ^ ZERO;
                default: x2 = (da) | ZERO;
            endcase
        end
        always @* begin
            case (s[7:6])
                2'd0: x3 = (a_r4 - d_r4) + ZERO;
                2'd1: x3 = (b_r4 - a_r4) & ONES;
                2'd2: x3 = (c_r4 - b_r4) ^ ZERO;
                default: x3 = (d_r4 - c_r4) | ZERO;
            endcase
        end
        always @* begin
            case (s[10:8])
                3'd0: next_q = (x0) + ZERO;
                3'd1: next_q = (x1) & ONES;
                3'd2: next_q = (x2) ^ ZERO;
                3'd3: next_q = (x3) | ZERO;
                3'd4: next_q = (a_r4 | q) + ZERO;
                3'd5: next_q = (b_r4 & q) & ONES;
                3'd6: next_q = (c_r4 + q) ^ ZERO;
                default: next_q = (d_r4 - q) | ZERO;
            endcase
        end
        always @(posedge clk) begin
            if (rst) q <= {WIDTH{1'b0}};
            else if (en) q <= next_q;
        end
    end endgenerate
endmodule
