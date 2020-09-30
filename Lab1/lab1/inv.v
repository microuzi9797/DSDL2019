module inv(in, out);
	output out;
	input in;
	supply0 a;
	supply1 b;
	nmos(out, a, in);
	pmos(out, b, in);
endmodule

module inv_tb;
	reg in;
	wire out;
	inv circuit(in, out);
	
	integer k = 0;
	wire x;
	reg y, z;
	assign x = k;
	initial begin
		// $display();
		// $dumpfile("test.vcd");
		// $dumpvars(0, inv_tb);
		
		$display();
		$display({2'b10, 2'b11} == 4'o13, " <- {2'b10, 2'b11} == 4'o13");
		
		$display();
		$write("This");
		$display(" also", " works.");
		
		$display();
		$display("t=%2d, Test begin", $time);
		$display("t=%2d, in=%d, out=%d <- initial status, ",
			$time, in, out);
		
		$display();
		$display(" t   in out k x y z");
		$display("===================");
		$monitor("%2d /  %d  %d %d %d %d %d",
			$time, in, out, k[3:0], x, y, z);
		in = 0;
		for(k=0; k<8; k=k+1) begin
			in = ~in;
			#1;
		end
		y = 1;
		z = 0;
		#1;
		y <= z;
		z <= y;
		#1;
		y = z;
		z = y;
	end
endmodule