`timescale 1ns/100ps
module testbench;

    reg [4:0] Ra, Rb, Rw;
    reg [31:0] busW;
    reg RegWr;
    reg WrClk;
    wire [31:0] busA, busB;

   
    register_file rf (
        .Ra(Ra),
        .Rb(Rb),
        .Rw(Rw),
        .busW(busW),
        .RegWr(RegWr),
        .WrClk(WrClk),
        .busA(busA),
        .busB(busB)
    );


    always #5 WrClk = ~WrClk;
    initial begin 
		$dumpfile("regst.vcd");
 		$dumpvars;
 		#180
 		$finish;
 		end
    initial begin
 	   
        WrClk = 0;
        RegWr = 0; //enable
        Ra = 0; //rs1
        Rb = 0; //rs2
        Rw = 0; //rd
        busW = 0;

        // write x1
        #10 RegWr = 1; Rw = 5'b00001; busW = 32'b01010010101101010010101101010010;
        //$display ("busw = 32'hDEADBEEF = %b" , busw);
        // write x2
        #10 Rw = 5'b00010; busW = 32'b01011011101101011010101111010110;
	//$display ("busw = 32'hCAFEBABE = %b" , busw);
        // read
        #10 RegWr = 0; Ra = 5'b00001; Rb = 5'b00010; busW = 32'b11111111101101011010101111010110;

        // write x0
        #10 RegWr = 1; Rw = 5'b00000; busW = 32'b0101101110100101001000001001110;

        // check x0 
        #10 Ra = 5'b00000; Rb = 5'b00001;
	// write x4 + check
        #10 RegWr = 1; Rw = 5'b00100; busW = 32'b01010010101101010010101101010010; Ra = 5'b00101; Rb = 5'b00010;
        //$display ("busw = 32'hDEADBEEF = %b" , busw);
        // write x5 + check
        #10 RegWr = 1; Rw = 5'b00101; busW = 32'b01010010101101010010101101010010; Ra = 5'b00100; Rb = 5'b00101;
        //$display ("busw = 32'hDEADBEEF = %b" , busw);
         // write x10  + check
        #10 RegWr = 1; Rw = 5'b01010; busW = 32'b01010010101101010010101101010010;  Ra = 5'b00101; Rb = 5'b01010;
         // write x30 + check
        #10 RegWr = 1; Rw = 5'b11101; busW = 32'b01010010101101010010101101010010; Ra = 5'b11101; Rb = 5'b01010;
        // write x12
        #10 RegWr = 1; Rw = 5'b01100; busW = 32'b01010010101101010010101101010010; Ra = 5'b11101; Rb = 5'b01100;
        #20 $finish;
    end
endmodule
