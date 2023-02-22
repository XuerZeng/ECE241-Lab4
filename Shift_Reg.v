module part3(clock, reset, ParallelLoadn, RotateRight, ASRight, Data_IN, Q);
	input [7:0] Data_IN;
	input reset;
	input clock;
	input ParallelLoadn;
	input RotateRight;
	input ASRight;
	output [7:0] Q;
	wire [7:0] store;
	assign store = Q;
	wire m;
	mux2to1 u0 (store[0],store[7],ASRight,m);
	rotating bit0(store[1], store[7], clock, reset, ParallelLoadn, RotateRight, Data_IN[0], Q[0]);
	rotating bit1(store[2], store[0], clock, reset, ParallelLoadn, RotateRight, Data_IN[1], Q[1]);
	rotating bit2(store[3], store[1], clock, reset, ParallelLoadn, RotateRight, Data_IN[2], Q[2]);
	rotating bit3(store[4], store[2], clock, reset, ParallelLoadn, RotateRight, Data_IN[3], Q[3]);
	rotating bit4(store[5], store[3], clock, reset, ParallelLoadn, RotateRight, Data_IN[4], Q[4]);
	rotating bit5(store[6], store[4], clock, reset, ParallelLoadn, RotateRight, Data_IN[5], Q[5]);
	rotating bit6(store[7], store[5], clock, reset, ParallelLoadn, RotateRight, Data_IN[6], Q[6]);
	rotating bit7(m, store[6], clock, reset, ParallelLoadn, RotateRight, Data_IN[7], Q[7]);	
endmodule



module rotating(left, right, clock, reset, parallel, loadleft, data, Q);
	input data, right, left, clock, reset, parallel, loadleft;
	output Q;
	wire [1:0] connect;
	
	mux2to1 r0(right, left, loadleft, connect[0]);
	mux2to1 r1(data, connect[0], parallel, connect[1]);
	
	flipflop r2(connect[1], Q, clock, reset);
endmodule

module mux2to1(x,y,s,m);
	input x; 
    	input y; 
    	input s; 
    	output m; 
  
    	assign m = (s & y) | (~s & x);
endmodule


module flipflop(d,q,clock,reset);
	input d,clock,reset;
	output q;
	reg temp;
	
	always @(posedge clock)
	begin
		if(reset == 1)
			temp<=1'b0;
		else
			temp<=d;
	end
	assign q = temp;
endmodule
