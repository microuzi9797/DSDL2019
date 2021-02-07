// sequential multiplier
module mult_seq(
	output reg[7:0] P, // product
	output reg ready,   // product is ready to be read
	input[3:0] A, B,    // multiplicand and multiplier
	input clk, load		// clock (posedge) and load (negedge)
	);
	// internal structures
	reg[3:0] a, b;
	reg[2:0] counter;
	// initialize
	initial begin
		ready <= 1;
	end
	// load a, b on negedge
	always @(negedge load) begin
		a <= A;
		b <= B;
		P <= 0;
		ready <= 0;
		counter <= 0;
	end
	// add partial products sequentially
	always @(posedge clk) begin
		if(!ready) begin
			if(counter==4) begin
				ready <= 1;
			end
			else begin
				P <= #7 (P<<1) + a*b[3]; // delay of the 4-bit adder
				b <= b<<1;
				counter <= #6 counter+1; // delay of the 3-bit adder
			end
		end
	end
endmodule

// test bench
module mult_tb();
	// dump
	initial begin
		$dumpfile("mult_seq.vcd");
		$dumpvars(0, mult_tb);
	end
	// clock cycle = 10 ticks
	reg clock = 1;
	always
		#5 clock <= ~clock;
	// multiplier
	reg[3:0] A, B;
	reg load = 1;
	wire ready;
	wire[7:0] P;
	reg[7:0] P_ref;
	mult_seq mult(P, ready, A, B, clock, load);
	always @(A, B)
		P_ref <= A*B;
	// input sequence
	initial begin
		A <= 9;
		B <= 12;
		#1 load <= 0;
		#1 load <= 1;
		#58;
		$finish;
	end
endmodule