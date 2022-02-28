module fpadder( input [15:0] A, input [15:0] B, input clk, input rst, output reg [15:0] C);

reg sign_a, sign_b;
reg sign_c;
reg [4:0] exp_a, exp_b, exp_c;
reg [9:0] man_a, man_b;
reg [10:0] nor_man_a, nor_man_b;
reg [11:0] sum_c;
reg [11:0] nor_sum_c;
reg [4:0] nor_exp_c;

always @(*)
	begin
	sign_a = A[15];    //extracting signs, mantissas and exponents from inputs A & B
	exp_a = A[14:10];
	man_a = A[9:0];
	sign_b = B[15];
	exp_b = B[14:10];
	man_b = B[9:0];
	end

always @(*) begin
	if (exp_a > exp_b) begin  //Comparing exponents and shifting the smaller mantissa
		exp_c = exp_a;
		nor_man_a = {1'b1, man_a};
		nor_man_b = {1'b1, man_b} >> (exp_a - exp_b);
		end
	else begin
		exp_c = exp_b;
		nor_man_b = {1'b1, man_b};
		nor_man_a = {1'b1, man_a} >> (exp_b - exp_a);
		end

	if (sign_a == sign_b) begin  //Adding the mantissas if they're both of same sign
		sign_c = sign_a;
		sum_c = nor_man_a + nor_man_b;
	end
	else if(nor_man_a > nor_man_b) begin //Comparing the aligned mantissas and adding them
			sign_c = sign_a;
			sum_c = nor_man_a + ((~nor_man_b) + 1'b1);
		end
	else if(nor_man_b > nor_man_a) begin
			sign_c = sign_b;
			sum_c = nor_man_b + ((~nor_man_a) + 1'b1);
		end

	if (sum_c[11] == 1'b1) begin     //Normalizing both the mantissa and exponent
		nor_sum_c = sum_c >> 1'b1;
		nor_exp_c = (exp_c  + 'b01);
		end
	else if (sum_c[10] == 1'b1) begin
		nor_sum_c = sum_c ;
		nor_exp_c = exp_c ;
		end
	else if (sum_c[9] == 1'b1) begin
		nor_sum_c = sum_c << 2'b01;
		nor_exp_c = (exp_c - 'b01);
		end
	else if (sum_c[8] == 1'b1) begin
		nor_sum_c = sum_c << 3'b10;
		nor_exp_c = (exp_c - 'b10);
		end
	else if (sum_c[7] == 1'b1) begin
		nor_sum_c = sum_c << 2'b11;
		nor_exp_c = (exp_c - 'b11);
		end
	else if (sum_c[6] == 1'b1) begin
		nor_sum_c = sum_c << 3'b100;
		nor_exp_c = (exp_c - 'b100);
		end
	else if (sum_c[5] == 1'b1) begin
		nor_sum_c = sum_c << 3'b101;
		nor_exp_c = (exp_c - 'b101);
		end
	else if (sum_c[4] == 1'b1) begin
		nor_sum_c = sum_c << 3'b110;
		nor_exp_c = (exp_c - 'b110);
		end
	else if (sum_c[3] == 1'b1) begin
		nor_sum_c = sum_c << 3'b111;
		nor_exp_c = (exp_c - 'b111);
		end
	else if (sum_c[2] == 1'b1) begin
		nor_sum_c = sum_c << 4'b1000;
		nor_exp_c = (exp_c - 'b1000);
		end
	else if (sum_c[1] == 1'b1) begin
		nor_sum_c = sum_c << 4'b1001;
		nor_exp_c = (exp_c - 'b1001);
		end
	else begin
		nor_sum_c = sum_c;
		nor_exp_c = exp_c;
	end

		if( (A==0) && (B==0)) begin //Special case if both the inputs are zero
				C = 0; end 
			else begin
		 C = {sign_c,nor_exp_c[4:0], nor_sum_c[9:0]}; // Final adder SUM
		end
end

endmodule
