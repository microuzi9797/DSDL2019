`ifndef ADDERS
`define ADDERS
`include "gates.v"

// half adder
module HA(output C, S, input A, B);
	XOR g0(S, A, B);
	AND g1(C, A, B);
endmodule

// full adder
module FA(output C, S, input A, B, CI);
	wire c0, s0, c1, s1;
	HA ha0(c0, s0, A, B);
	HA ha1(c1, s1, s0, CI);
	assign S = s1;
	OR or0(C, c0, c1);
endmodule

// adder without delay, register-transfer level modeling
module adder_rtl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	assign {C3, S} = A+B+C0;
endmodule

//  ripple-carry adder, gate level modeling
module rca_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	wire[3:0] c;
	assign c[0] = C0;
	assign C3 = c[3];
	FA fa0(c[1], S[0], A[0], B[0], c[0]);
	FA fa1(c[2], S[1], A[1], B[1], c[1]);
	FA fa2(c[3], S[2], A[2], B[2], c[2]);
endmodule

// carry-lookahead adder, gate level modeling
module cla_gl(
	output C3,       // carry output
	output[2:0] S,   // sum
	input[2:0] A, B, // operands
	input C0         // carry input
	);
	
	// // [cascaded] 23 ticks
	// // generate and propagate
	// wire[2:0] p, g;
	// AND g0(g[0], A[0], B[0]);
	// AND g1(g[1], A[1], B[1]);
	// AND g2(g[2], A[2], B[2]);
	// XOR p0(p[0], A[0], B[0]);
	// XOR p1(p[1], A[1], B[1]);
	// XOR p2(p[2], A[2], B[2]);
	// // carry
	// wire[3:0] c;
	// assign c[0] = C0;
	// assign C3 = c[3];
	// AND  c11(w11, p[0], c[0]);
	// OR   c1(c[1], g[0], w11);
	// AND  c21(w21, p[1], c[1]);
	// OR   c2(c[2], g[1], w21);
	// AND  c31(w31, p[2], c[2]);
	// OR   c3(c[3], g[2], w31);
	// // sum
	// XOR s0(S[0], p[0], c[0]);
	// XOR s1(S[1], p[1], c[1]);
	// XOR s2(S[2], p[2], c[2]);
	
	// // [XOR] 22 ticks
	// // generate and propagate
	// wire[2:0] p, g;
	// AND g0(g[0], A[0], B[0]);
	// AND g1(g[1], A[1], B[1]);
	// AND g2(g[2], A[2], B[2]);
	// XOR p0(p[0], A[0], B[0]);
	// XOR p1(p[1], A[1], B[1]);
	// XOR p2(p[2], A[2], B[2]);
	// // carry
	// wire[3:0] c;
	// assign c[0] = C0;
	// assign C3 = c[3];
	// AND  c11(w11, c[0], p[0]);
	// AND  c21(w21, g[0], p[1]);
	// AND4 c22(w22, c[0], p[0], p[1], 1);
	// AND  c31(w31, g[1], p[2]);
	// AND4 c32(w32, g[0], p[1], p[2], 1);
	// AND4 c33(w33, c[0], p[0], p[1], p[2]);
	// OR   c1(c[1], g[0], w11);
	// OR4  c2(c[2], g[1], w21, w22, 0);
	// OR4  c3(c[3], g[2], w31, w32, w33);
	// // sum
	// wire[3:1] co; // carry output of the full adders, not used
	// FA s0(co[1], S[0], A[0], B[0], c[0]);
	// FA s1(co[2], S[1], A[1], B[1], c[1]);
	// FA s2(co[3], S[2], A[2], B[2], c[2]);
	
	// [standard] 20 ticks
	// generate and propagate
	wire[2:0] p, g;
	AND g0(g[0], A[0], B[0]);
	AND g1(g[1], A[1], B[1]);
	AND g2(g[2], A[2], B[2]);
	OR p0(p[0], A[0], B[0]);
	OR p1(p[1], A[1], B[1]);
	OR p2(p[2], A[2], B[2]);
	// carry
	wire[3:0] c;
	assign c[0] = C0;
	assign C3 = c[3];
	AND  c11(w11, c[0], p[0]);
	AND  c21(w21, g[0], p[1]);
	AND4 c22(w22, c[0], p[0], p[1], 1);
	AND  c31(w31, g[1], p[2]);
	AND4 c32(w32, g[0], p[1], p[2], 1);
	AND4 c33(w33, c[0], p[0], p[1], p[2]);
	OR   c1(c[1], g[0], w11);
	OR4  c2(c[2], g[1], w21, w22, 0);
	OR4  c3(c[3], g[2], w31, w32, w33);
	// sum
	wire[3:1] co; // carry output of the full adders, not used
	FA s0(co[1], S[0], A[0], B[0], c[0]);
	FA s1(co[2], S[1], A[1], B[1], c[1]);
	FA s2(co[3], S[2], A[2], B[2], c[2]);
	
	// // [AND3, OR3] 17 ticks
	// // generate and propagate
	// wire[2:0] p, g;
	// AND g0(g[0], A[0], B[0]);
	// AND g1(g[1], A[1], B[1]);
	// AND g2(g[2], A[2], B[2]);
	// OR p0(p[0], A[0], B[0]);
	// OR p1(p[1], A[1], B[1]);
	// OR p2(p[2], A[2], B[2]);
	// // carry
	// wire[3:0] c;
	// assign c[0] = C0;
	// assign C3 = c[3];
	// AND  c11(w11, c[0], p[0]);
	// AND  c21(w21, g[0], p[1]);
	// AND3 c22(w22, p[0], p[1], c[0]);
	// AND  c31(w31, g[1], p[2]);
	// AND3 c32(w32, p[2], p[1], g[0]);
	// AND4 c33(w33, c[0], p[0], p[1], p[2]);
	// OR   c1(c[1], g[0], w11);
	// OR3  c2(c[2], g[1], w21, w22);
	// OR4  c3(c[3], g[2], w31, w32, w33);
	// // sum
	// wire[3:1] co; // carry output of the full adders, not used
	// FA s0(co[1], S[0], A[0], B[0], c[0]);
	// FA s1(co[2], S[1], A[1], B[1], c[1]);
	// FA s2(co[3], S[2], A[2], B[2], c[2]);
	
	// // [NAND, NOR] 13 ticks
	// // generate and propagate
	// wire[2:0] np, p, ng, g;
	// NAND ng0(ng[0], A[0], B[0]);
	// NAND ng1(ng[1], A[1], B[1]);
	// NAND ng2(ng[2], A[2], B[2]);
	// NOT g0(g[0], ng[0]);
	// NOT g1(g[1], ng[1]);
	// NOT g2(g[2], ng[2]);
	// NOR np0(np[0], A[0], B[0]);
	// NOR np1(np[1], A[1], B[1]);
	// NOR np2(np[2], A[2], B[2]);
	// NOT p0(p[0], np[0]);
	// NOT p1(p[1], np[1]);
	// NOT p2(p[2], np[2]);
	// // carry
	// wire[3:0] c;
	// assign c[0] = C0;
	// assign C3 = c[3];
	// NOT n0(nc0, C0);
	// NAND c11(w11, c[0], p[0]);
	// NAND c1(c[1], ng[0], w11);
	// NOR c21(w21, ng[0], np[1]);
	// NOR c22_0(w22_0, nc0, np[0]);
	// NAND c22(w22, w22_0, p[1]);
	// NOR c2_0(w2_0, g[1], w21);
	// NAND c2(c[2], w2_0, w22);
	// NOR c31(w31, ng[1], np[2]);
	// NAND c32_0(w32_0, g[0], p[1]);
	// NOR c32(w32, w32_0, np[2]);
	// NAND c33_0(w33_0, c[0], p[0]);
	// NAND c33_1(w33_1, p[1], p[2]);
	// NOR c33(w33, w33_0, w33_1);
	// NOR c3_0(w3_0, g[2], w31);
	// NOR c3_1(w3_1, w32, w33);
	// NAND c3(c[3], w3_0, w3_1);
	// // sum
	// wire[3:1] co; // carry output of the full adders, not used
	// FA s0(co[1], S[0], A[0], B[0], c[0]);
	// FA s1(co[2], S[1], A[1], B[1], c[1]);
	// FA s2(co[3], S[2], A[2], B[2], c[2]);
endmodule

`endif