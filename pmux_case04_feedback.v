
module pmux_case04_feedback #(
    parameter integer LANES = 2,
    parameter integer WIDTH = 8
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
        reg [WIDTH-1:0] x0, x1, x2, next_q;

        wire [WIDTH-1:0] ZERO = {WIDTH{1'b0}};
        wire [WIDTH-1:0] ONES = {WIDTH{1'b1}};

        always @* begin
            case (s[1:0])
                2'd0: x0 = (a ^ q) + ZERO;
                2'd1: x0 = (b + q) & ONES;
                2'd2: x0 = (c - q) ^ ZERO;
                default: x0 = (d) | ZERO;
            endcase
        end
        always @* begin
            case (s[3:2])
                2'd0: x1 = x0;
                2'd1: x1 = (a + c) + ZERO;
                2'd2: x1 = (b ^ d) & ONES;
                default: x1 = (q) ^ ZERO;
            endcase
        end
        always @* begin
            case (s[5:4])
                2'd0: x2 = x1;
                2'd1: x2 = x0;
                2'd2: x2 = (c + d) + ZERO;
                default: x2 = (a ^ q) | ZERO;
            endcase
        end
        always @* begin
            case (s[7:6])
                2'd0: next_q = (x2) + ZERO;
                2'd1: next_q = (x1) & ONES;
                2'd2: next_q = (x0) ^ ZERO;
                default: next_q = (b - c) + ZERO;
            endcase
        end
        always @(posedge clk or posedge rst) begin
            if (rst) q <= {WIDTH{1'b0}};
            else if (en && s[15]) q <= next_q;
        end
    end endgenerate
endmodule
