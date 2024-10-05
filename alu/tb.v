`timescale 1ns/100ps

module ALU_tb;

    reg [31:0] A, B;
    reg [1:0] ALUOp;
    reg [2:0] funct3;
    reg [4:0] shamt;
    reg [6:0] funct7;
    wire [31:0] Result;
    wire Zero;
    wire Less;

    // ALU模組實例化
    ALU uut (
        .A(A),
        .B(B),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .shamt(shamt),
        .funct7(funct7),
        .Result(Result),
        .Zero(Zero),
        .Less(Less)
    );

    // 初始設置
    initial begin
        $dumpfile("ALU_tb.vcd");
        $dumpvars(0, ALU_tb);

        // 測試加法 (ALUOp = 00, funct7 = 0000000)
        A = 32'h0000000A; B = 32'h00000014; ALUOp = 2'b00; funct7 = 7'b0000000; #10;
        $display("Add: A = %h, B = %h, Result = %h, Zero = %b, Less = %b", A, B, Result, Zero, Less);

        // 測試減法 (ALUOp = 00, funct7 = 0100000)
        A = 32'h00000014; B = 32'h0000000A; ALUOp = 2'b00; funct7 = 7'b0100000; #10;
        $display("Sub: A = %h, B = %h, Result = %h, Zero = %b, Less = %b", A, B, Result, Zero, Less);

        // 測試 AND (ALUOp = 01, funct3 = 000)
        A = 32'h0F0F0F0F; B = 32'h00FF00FF; ALUOp = 2'b01; funct3 = 3'b000; #10;
        $display("AND: A = %h, B = %h, Result = %h, Zero = %b, Less = %b", A, B, Result, Zero, Less);

        // 測試 OR (ALUOp = 01, funct3 = 001)
        A = 32'h0F0F0F0F; B = 32'h00FF00FF; ALUOp = 2'b01; funct3 = 3'b001; #10;
        $display("OR: A = %h, B = %h, Result = %h, Zero = %b, Less = %b", A, B, Result, Zero, Less);

        // 測試 XOR (ALUOp = 01, funct3 = 010)
        A = 32'h0F0F0F0F; B = 32'h00FF00FF; ALUOp = 2'b01; funct3 = 3'b010; #10;
        $display("XOR: A = %h, B = %h, Result = %h, Zero = %b, Less = %b", A, B, Result, Zero, Less);

        // 測試 SLL (左移操作) (ALUOp = 10, funct3 = 000)
        A = 32'h00000001; shamt = 5; ALUOp = 2'b10; funct3 = 3'b000; #10;
        $display("SLL: A = %h, shamt = %d, Result = %h, Zero = %b, Less = %b", A, shamt, Result, Zero, Less);

        // 測試 SRL (邏輯右移) (ALUOp = 10, funct3 = 101, funct7 = 0000000)
        A = 32'h00000020; shamt = 2; ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0000000; #10;
        $display("SRL: A = %h, shamt = %d, Result = %h, Zero = %b, Less = %b", A, shamt, Result, Zero, Less);

        // 測試 SRA (算術右移) (ALUOp = 10, funct3 = 101, funct7 = 0100000)
        A = 32'hFFFFFFE0; shamt = 2; ALUOp = 2'b10; funct3 = 3'b101; funct7 = 7'b0100000; #10;
        $display("SRA: A = %h, shamt = %d, Result = %h, Zero = %b, Less = %b", A, shamt, Result, Zero, Less);

        // 測試 SLT (小於比較，有符號) (ALUOp = 11, funct3 = 010)
        A = 32'h00000001; B = 32'h00000002; ALUOp = 2'b11; funct3 = 3'b010; #10;
        $display("SLT: A = %h, B = %h, Result = %h, Zero = %b, Less = %b", A, B, Result, Zero, Less);

        // 測試 SLTU (小於比較，無符號) (ALUOp = 11, funct3 = 011)
        A = 32'hFFFFFFFE; B = 32'h00000001; ALUOp = 2'b11; funct3 = 3'b011; #10;
        $display("SLTU: A = %h, B = %h, Result = %h, Zero = %b, Less = %b", A, B, Result, Zero, Less);

        // 測試零輸出
        A = 32'h00000000; B = 32'h00000000; ALUOp = 2'b00; funct7 = 7'b0000000; #10;
        $display("Zero Test: A = %h, B = %h, Result = %h, Zero = %b, Less = %b", A, B, Result, Zero, Less);

        // 結束測試
        $finish;
    end
endmodule

