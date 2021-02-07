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

	// Implement your code here.
	// Hint: should be done in 1 line.
	// You can use this adder to debug the gate-level implemented adder.
	assign {C3, S} = A + B + C0;
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

	// Implement your code here.
	// generate & propagate
	wire [2:0] G, P;
	AND g0(G[0], A[0], B[0]);
	AND g1(G[1], A[1], B[1]);
	AND g2(G[2], A[2], B[2]);
	OR p0(P[0], A[0], B[0]);
	OR p1(P[1], A[1], B[1]);
	OR p2(P[2], A[2], B[2]);
	// 3-bit carry look-ahead
	wire [3:0] c;
	assign c[0] = C0;
	assign C3 = c[3];
	// C1
	AND pc00(W1, P[0], c[0]);
	OR c1(c[1], G[0], W1);
	// C2
	AND gp01(W21, G[0], P[1]);
	AND4 cpp001(W22, c[0], P[0], P[1], 1);
	OR4 c2(c[2], G[1], W21, W22, 0);
	// C3
	AND gp12(W31, G[1], P[2]);
	AND4 gpp012(W32, G[0], P[1], P[2], 1);
	AND4 cppp0012(W33, c[0], P[0], P[1], P[2]);
	OR4 c3(c[3], G[2], W31, W32, W33);
	// S
	wire [3:1] co;
	FA fa0(co[1], S[0], A[0], B[0], c[0]);
	FA fa1(co[2], S[1], A[1], B[1], c[1]);
	FA fa2(co[3], S[2], A[2], B[2], c[2]);
endmodule

`endif