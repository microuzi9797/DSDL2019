`include "adders.v"
`include "gates.v"

module fa_tb();
	wire s, c;
	reg a, b, ci;
	FA fa0(c, s, a, b, ci);
	
	integer i;
	initial begin
		$display("time | abci cs");
		$monitor("%4d | %b%b%b  %b%b",
			$time, a, b, ci, c, s);
		for(i=0; i<10; i=i+1) begin
			$display("====================");
			{a, b ,ci} <= i;
			#100;
		end
	end
endmodule