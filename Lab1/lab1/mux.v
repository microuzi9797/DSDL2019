module mux(out, sel, in1, in2);
	output out;
	input sel, in1, in2;
	// the compiler will connect the wires for you,
	// so actually it's not reuqired to declare the wires.
	// wire iv_sel, a1_o, a2_o;
	not n1(iv_sel, sel);
	and a1(a1_o, in1, sel);
	and a2(a2_o, in2, iv_sel);
	or o1(out, a1_o, a2_o);
endmodule

// module mux(out, sel, in1, in2);
	// output out;
	// input sel, in1, in2;
	// reg out;
	// always @(sel, in1, in2)
		// if(sel==1)
			// out = in1;
		// else
			// out = in2;
// endmodule

// module mux(out, sel, in1, in2);
	// output out;
	// input sel, in1, in2;
	// assign out = sel&in1
		// | ~sel&in2;
// endmodule

// module mux(out, sel, in1, in2);
	// output out;
	// input sel, in1, in2;
	// assign out = sel?in1:in2;
// endmodule

module mux_tb();
	reg sel, in1, in2;
	wire out;
	mux m0(out, sel, in1, in2);
	integer k;
	initial begin
		$display(" t / sel in1 in2 out");
		$display("====================");
		$monitor("%2d /  %b   %b   %b   %b",
			$time, sel, in1, in2, out);
		for(k=0; k<8; k=k+1) begin
			{sel, in1, in2} <= k;
			#1;
			// if(k==4)
				// $finish;
		end
	end
endmodule