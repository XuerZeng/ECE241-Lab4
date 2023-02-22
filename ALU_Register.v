module part2(Clock, Reset_b, Data, Function, ALUout);
	input [3:0] Data;
	input Clock;
	input Reset_b;
	input [2:0] Function;
	wire [7:0] temp;
	wire [7:0] register;
	output [7:0] ALUout;
	ALU p0(Data, register[3:0], Function, temp);
	register p1(Clock, Reset_b, temp, register);
	assign ALUout = register;	
endmodule

module ALU(A,B,Function,ALUout);
	input [3:0] A;
	input [3:0] B;
	input [2:0] Function;
	reg [7:0] calc;
	output [7:0] ALUout;
	wire [4:0] adder;
	wire [3:0] carry;
	FourBitFA p0(.a(A[3:0]), .b(B[3:0]), .c_in(1'b0), .s(adder[4:0]), .c_out(carry[3:0]));
	always @(*)
		begin
			case(Function)
			    3'b000: calc = adder;

			    3'b001: calc = A + B;

			    3'b010: 
				calc = {{4{B[3]}},B};
				
			    3'b011: 
				begin
				    if((A>0) | (B>0))
					calc = 8'b00000001;
		    		    else
					calc = 8'b0;
				end
			    3'b100: 
				begin
				    if(&{A,B})
					calc = 8'b00000001;
		    		    else
					calc = 8'b00000000;
				end
	
			    3'b101: calc = B<<A;
			    3'b110: calc = A*B;
			    3'b111: calc = ALUout;

			    default: calc = 8'b0;
			endcase
		end
	assign ALUout = calc;
endmodule

module register(Clock, reset, ALUout, registor);
	input [7:0] ALUout;
	input Clock, reset;
	output [7:0] registor;
	reg [7:0] regout;
	always @(posedge Clock)
	    if(reset==0)
		regout<=8'b0;
	    else
		regout<=ALUout;
	assign registor = regout;
endmodule	

module FA(a,b,c_in,s,c_out);
	input a,b,c_in;
	output s , c_out;
	assign s=(c_in ^ a ^ b);
	assign c_out=(a&b)|(c_in&a)|(c_in&b);
endmodule

module FourBitFA(a,b,c_in,s,c_out);
	input [3:0] a,b;
	input c_in;
	output [4:0] s;
	output [3:0] c_out;

	
	wire c1 , c2 , c3 , c4;
	
	FA bit0(a[0],b[0],c_in,s[0],c1);
	FA bit1(a[1],b[1],c1,s[1],c2);
	FA bit2(a[2],b[2],c2,s[2],c3);
	FA bit3(a[3],b[3],c3,s[3],s[4]);

	
endmodule

module hex_decoder(c,display);
	input [3:0] c;
	output[6:0] display;
	
	assign c3 = c[0];
	assign c2 = c[1];
	assign c1 = c[2];
	assign c0 = c[3];
	
	assign display[0] = ~((~c3&~c2&~c1&~c0) + (~c3&~c2&c1&~c0) + (~c3&~c2&c1&c0) + (~c3&c2&~c1&c0) + (~c3&c2&c1&~c0) + (~c3&c2&c1&c0) + (c3&~c2&~c1&~c0) + (c3&~c2&~c1&c0) + (c3&~c2&c1&~c0) + (c3&c2&~c1&~c0) + (c3&c2&c1&~c0) + (c3&c2&c1&c0));
        assign display[1] = ~((~c3&~c2&~c1&~c0) + (~c3&~c2&~c1&c0) + (~c3&~c2&c1&~c0) + (~c3&~c2&c1&c0) + (~c3&c2&~c1&~c0) + (~c3&c2&c1&c0) + (c3&~c2&~c1&~c0) + (c3&~c2&~c1&c0) + (c3&~c2&c1&~c0) + (c3&c2&~c1&c0));
        assign display[2] = ~((~c3&~c2&~c1&~c0) + (~c3&~c2&~c1&c0) + (~c3&~c2&c1&c0) + (~c3&c2&~c1&~c0) + (~c3&c2&~c1&c0) + (~c3&c2&c1&~c0) + (~c3&c2&c1&c0) + (c3&~c2&~c1&~c0) + (c3&~c2&~c1&c0) + (c3&~c2&c1&~c0) + (c3&~c2&c1&c0) + (c3&c2&~c1&c0));
        assign display[3] = ~((~c3&~c2&~c1&~c0) + (~c3&~c2&c1&~c0) + (~c3&~c2&c1&c0) + (~c3&c2&~c1&c0) + (~c3&c2&c1&~c0) + (c3&~c2&~c1&~c0) + (c3&~c2&~c1&c0) + (c3&~c2&c1&c0) + (c3&c2&~c1&~c0) + (c3&c2&~c1&c0) + (c3&c2&c1&~c0));
        assign display[4] = ~((~c3&~c2&~c1&~c0) + (~c3&~c2&c1&~c0) + (~c3&c2&c1&~c0) + (c3&~c2&~c1&~c0) + (c3&~c2&c1&~c0) + (c3&~c2&c1&c0) + (c3&c2&~c1&~c0) + (c3&c2&~c1&c0) + (c3&c2&c1&~c0) + (c3&c2&c1&c0));
        assign display[5] = ~((~c3&~c2&~c1&~c0) + (~c3&c2&~c1&~c0) + (~c3&c2&~c1&c0) + (~c3&c2&c1&~c0) + (c3&~c2&~c1&~c0) + (c3&~c2&~c1&c0) + (c3&~c2&c1&~c0) + (c3&~c2&c1&c0) + (c3&c2&~c1&~c0) + (c3&c2&c1&~c0) + (c3&c2&c1&c0));
        assign display[6] = ~((~c3&~c2&c1&~c0) + (~c3&~c2&c1&c0) + (~c3&c2&~c1&~c0) + (~c3&c2&~c1&c0) + (~c3&c2&c1&~c0) + (c3&~c2&~c1&~c0) + (c3&~c2&~c1&c0) + (c3&~c2&c1&~c0) + (c3&~c2&c1&c0) + (c3&c2&~c1&c0) + (c3&c2&c1&~c0) + (c3&c2&c1&c0));
endmodule 

	
