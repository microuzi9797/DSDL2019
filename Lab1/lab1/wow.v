module wow();
	wire out;
	reg in;
	not #3 n0(out, in);
	integer i;
	initial begin
		$display("time / in out");
		$monitor("%4d /  %b  %b", $time, in, out);
		for(i=0; i<5; i=i+1) begin
			$display("-------------");
			in <= i; // high bits will be truncated
			#10;
		end
	end
endmodule