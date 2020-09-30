// pipelined sequential multiplier
module mult_pipe(
	output reg[7:0] P,  // product
	input[3:0] A, B,    // multiplicand and multiplier
	input clk		    // clock (posedge)
	);
	// stage 0 (input)
	reg[3:0] a_s0, b_s0;
	always @(posedge clk) begin
		a_s0 <= A;
		b_s0 <= B;
	end
	// stage 1
	wire[3:0] pp0 = a_s0 & {4{b_s0[0]}}; // ignore the delays of AND gates
	wire[4:1] pp1 = a_s0 & {4{b_s0[1]}}; // ignore the delays of AND gates
	reg[5:1] sum1;
	always @(pp0, pp1)
		sum1[5:1] <= #7 pp0[3:1] + pp1[4:1]; // delay of the 4-bit adder
	reg[3:0] a_s1, b_s1;
	reg[7:0] p_s1;
	always @(posedge clk) begin
		a_s1 <= a_s0;
		b_s1 <= b_s0;
		p_s1 <= {2'b00, sum1, pp0[0]};
	end
	// stage 2
	wire[5:2] pp2 = a_s1 & {4{b_s1[2]}}; // ignore the delays of AND gates
	reg[6:2] sum2;
	always @(p_s1, pp2)
		sum2[6:2] <= #7 p_s1[5:2] + pp2[5:2]; // delay of the 4-bit adder
	reg[3:0] a_s2, b_s2;
	reg[7:0] p_s2;
	always @(posedge clk) begin
		a_s2 <= a_s1;
		b_s2 <= b_s1;
		p_s2 <= {p_s1[7], sum2, p_s1[1:0]};
	end
	// stage 3 (outout)
	wire[6:3] pp3 = a_s2 & {4{b_s2[3]}}; // ignore the delays of AND gates
	reg[7:3] sum3;
	always @(p_s2, pp3)
		sum3[7:3] <= #7 p_s2[6:3] + pp3[6:3]; // delay of the 4-bit adder
	always @(posedge clk)
		P <= {sum3, p_s2[2:0]};
endmodule

// test bench
module mult_tb();
	// dump
	initial begin
		$dumpfile("mult_pipe.vcd");
		$dumpvars(0, mult_tb);
	end
	// clock cycle = 10 ticks
	reg clock = 1;
	always
		#5 clock <= ~clock;
	// multiplier
	reg[3:0] A, B;
	wire[7:0] P;
	reg[7:0] P_ref;
	mult_pipe mult(P, A, B, clock);
	always @(posedge clock)
		P_ref <= #30 A*B;
	// input sequence
	initial begin
		#9;
		A <= 9;
		B <= 12;
		#10;
		A <= 1;
		B <= 1;
		#10;
		A <= 8;
		B <= 15;
		#46;
		$finish;
	end
endmodule