
module test2 (clk, a,b,c,d,dataa,datab,datac,datad,out) ;

input a;
input b;
input c;
input d;
input clk;
input [4 : 0]dataa;
input [4 : 0]datab;
input [4 : 0]datac;
input [4 : 0]datad;
output[4:0] out;
reg[4:0]temp;

wire [4:0] ZERO = 5'b00000;
wire [4:0] ONES = 5'b11111;

wire [4:0] dataa_r1 = dataa + ZERO;
wire [4:0] dataa_r2 = dataa_r1 & ONES;
wire [4:0] dataa_r3 = dataa_r2 ^ ZERO;
wire [4:0] dataa_r4 = dataa_r3 | ZERO;

wire [4:0] datab_r1 = datab + ZERO;
wire [4:0] datab_r2 = datab_r1 & ONES;
wire [4:0] datab_r3 = datab_r2 ^ ZERO;
wire [4:0] datab_r4 = datab_r3 | ZERO;

wire [4:0] datac_r1 = datac + ZERO;
wire [4:0] datac_r2 = datac_r1 & ONES;
wire [4:0] datac_r3 = datac_r2 ^ ZERO;
wire [4:0] datac_r4 = datac_r3 | ZERO;

wire [4:0] datad_r1 = datad + ZERO;
wire [4:0] datad_r2 = datad_r1 & ONES;
wire [4:0] datad_r3 = datad_r2 ^ ZERO;
wire [4:0] datad_r4 = datad_r3 | ZERO;

always@(a or dataa_r4 or b or datab_r4 or c or datac_r4)

  begin
    case (1'b1) 
      a:
	  temp = dataa_r4;
      b:
	  temp = datab_r4;
      c:
	  temp = datac_r4;
	  d:
	  temp = datad_r4;
      default: temp =0 ;
    endcase
  end
  assign out = temp;
 
endmodule





				// a <= {1'b1};
				// b <= {1'b1};
				// c <= {1'b1};
				// dataa <= {5'b00001};
				// datab <= {5'b00011};
				// datac <= {5'b00111};