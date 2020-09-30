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
	
endmodule

`endif