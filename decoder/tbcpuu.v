`timescale 1ns/100ps

module Decoder_tb;

    // Input and output signals for Decoder
    reg [31:0] instr;       // 指令输入
    wire [4:0] rs1, rs2, rd;
    wire [2:0] funct3;
    wire [6:0] funct7, opcode;
    wire [31:0] imm;
    wire [4:0] shamt;
    wire RegWrite, MemRead, MemWrite, MemtoReg, ALUSrc, Branch;
    wire [1:0] ALUOp;

    // Instantiate the Decoder module
    Decoder uut (
        .instr(instr),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),
        .imm(imm),
        .shamt(shamt),
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    initial begin
        // Monitor outputs for each test
        $monitor("Time: %0t | Instr: %h | rs1: %0d | rs2: %0d | rd: %0d | funct3: %h | funct7: %h | imm: %h | RegWrite: %b | MemRead: %b | MemWrite: %b | ALUSrc: %b | ALUOp: %b",
                 $time, instr, rs1, rs2, rd, funct3, funct7, imm, RegWrite, MemRead, MemWrite, ALUSrc, ALUOp);

        // Test case 1: R-Type instruction (add)
        instr = 32'b0000000_00001_00010_000_00011_0110011;  // add x3, x1, x2
        #10;
        
        // Test case 2: I-Type instruction (addi)
        instr = 32'b000000000101_00001_000_00010_0010011;  // addi x2, x1, 5
        #10;

        // Test case 3: Load instruction (lw)
        instr = 32'b000000000101_00001_010_00010_0000011;  // lw x2, 5(x1)
        #10;

        // Test case 4: Store instruction (sw)
        instr = 32'b0000000_00010_00001_010_00001_0100011;  // sw x2, 5(x1)
        #10;

        // Test case 5: Branch instruction (beq)
        instr = 32'b0000000_00001_00010_000_00010_1100011;  // beq x1, x2, offset
        #10;

        // Test case 6: J-Type instruction (jal)
        instr = 32'b000000_000100_00000_110_00001_1101111; // jal x2, offset
        #10;

        $finish;
    end

endmodule

