`timescale 1ns/100ps

module ALU_tb;


    reg [31:0] A;
    reg [31:0] B;
    reg [2:0] ALUOp;
    reg [4:0] shamt;
    reg [6:0] funct7;

  
    wire [31:0] Result;
    wire Zero;


    ALU uut (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .shamt(shamt),
        .funct7(funct7),
        .Result(Result),
        .Zero(Zero)
    );

    initial begin
        $dumpfile("alu_tb.vcd"); 
        $dumpvars;
        
        // ++
        A = 32'd10;
        B = 32'd5;
        ALUOp = 3'b000;    
        funct7 = 7'b0000000; 
        shamt = 5'b00000;   
        #10;
        $display("Test 1: Add, A = %d, B = %d, Result = %d, Zero = %b", A, B, Result, Zero);

        // 減法
        A = 32'd10;
        B = 32'd5;
        ALUOp = 3'b000;    
        funct7 = 7'b0100000; 
        shamt = 5'b00000;   
        #10;
        $display("Test 2: Subtract, A = %d, B = %d, Result = %d, Zero = %b", A, B, Result, Zero);

        // and
        A = 32'b10101010;
        B = 32'b11001100;
        ALUOp = 3'b001;    
        funct7 = 7'b0000000; 
        shamt = 5'b00000;  
        #10;
        $display("Test 3: AND, A = %b, B = %b, Result = %b, Zero = %b", A, B, Result, Zero);

        // or
        A = 32'b10101010;
        B = 32'b11001100;
        ALUOp = 3'b010;    // or
        funct7 = 7'b0000000; // 
        shamt = 5'b00000;   // 
        #10;
        $display("Test 4: OR, A = %b, B = %b, Result = %b, Zero = %b", A, B, Result, Zero);

        // xor
        A = 32'b10101010;
        B = 32'b11001100;
        ALUOp = 3'b011;    // xor
        funct7 = 7'b0000000; 
        shamt = 5'b00000;  
        #10;
        $display("Test 5: XOR, A = %b, B = %b, Result = %b, Zero = %b", A, B, Result, Zero);

        //邏輯左移(A << shamt)
        A = 32'b00000000000000000000000000001111;
        B = 32'b00000000;   // no care
        ALUOp = 3'b100;    // 左移
        shamt = 5'd2;      // 左移2
        funct7 = 7'b0000000; 
        #10;
        $display("Test 6: SLL (Shift Left Logical), A = %b, shamt = %d, Result = %b, Zero = %b", A, shamt, Result, Zero);

    	//左移
        A = 32'b00000000000000000000000000001111;
        B = 32'b00000000;   
        ALUOp = 3'b101;    
        shamt = 5'd2;      
        funct7 = 7'b0000000; 
        #10;
        $display("Test 7: SRL (Shift Right Logical), A = %b, shamt = %d, Result = %b, Zero = %b", A, shamt, Result, Zero);

	//右移
        A = 32'b10000000000000000000000000001111; 
        B = 32'b00000000;   
        ALUOp = 3'b101; 
        shamt = 5'd2;      
        funct7 = 7'b0100000;
        #10;
        $display("Test 8: SRA (Shift Right Arithmetic), A = %b, shamt = %d, Result = %b, Zero = %b", A, shamt, Result, Zero);

	//SLT
        A = -32'd10;
        B = 32'd5;
        ALUOp = 3'b110;    
        funct7 = 7'b0000000; 
        #10;
        $display("Test 9: SLT (Signed Compare), A = %d, B = %d, Result = %d, Zero = %b", A, B, Result, Zero);

 	//SLTU
        A = 32'd10;
        B = 32'd5;
        ALUOp = 3'b111;    
        funct7 = 7'b0000000; 
        #10;
        $display("Test 10: SLTU (Unsigned Compare), A = %d, B = %d, Result = %d, Zero = %b", A, B, Result, Zero);

        $finish;
    end
endmodule

