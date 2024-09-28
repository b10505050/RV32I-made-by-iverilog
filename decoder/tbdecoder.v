`timescale 1ns/100ps

module Decoder_tb;
    // 输入
    reg [31:0] instr;
    // 输出
    wire [4:0] rs1, rs2, rd, shamt;
    wire [2:0] funct3;
    wire [6:0] funct7, opcode;
    wire [31:0] imm;
    wire RegWrite, MemRead, MemWrite, MemtoReg, ALUSrc, Branch;
    wire [1:0] ALUOp;

    // 实例化解码器
    Decoder uut (
        .instr(instr),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .funct3(funct3),
        .funct7(funct7),
        .opcode(opcode),
        .imm(imm),
        .shamt(shamt),           // 添加 shamt 信号
        .RegWrite(RegWrite),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    initial begin
        $dumpfile("decoder_tb.vcd");
        $dumpvars(0, Decoder_tb);

        // R-Type (add x1, x2, x3)
        instr = 32'b0000000_00011_00010_000_00001_0110011; // add x1, x2, x3
        #10;
        $display("R-Type: add, rs1 = %d, rs2 = %d, rd = %d, funct3 = %b, funct7 = %b, RegWrite = %b", rs1, rs2, rd, funct3, funct7, RegWrite);

        // I-Type (addi x1, x2, 1)
        instr = 32'b000000000001_00010_000_00001_0010011; // addi x1, x2, 1
        #10;
        $display("I-Type: addi, rs1 = %d, imm = %d, rd = %d, ALUSrc = %b, RegWrite = %b", rs1, imm, rd, ALUSrc, RegWrite);

        // S-Type (sw x1, 0(x2))
        instr = 32'b0000000_00001_00010_010_00000_0100011; // sw x1, 0(x2)
        #10;
        $display("S-Type: sw, rs1 = %d, rs2 = %d, imm = %d, MemWrite = %b", rs1, rs2, imm, MemWrite);

        // B-Type (beq x1, x2, offset)
        instr = 32'b0000000_00010_00001_000_00010_1100011; // beq x1, x2, offset
        #10;
        $display("B-Type: beq, rs1 = %d, rs2 = %d, imm = %d, Branch = %b", rs1, rs2, imm, Branch);

        // J-Type (jal x1, offset)
        instr = 32'b000000000100_00000_110_00001_1101111; // jal x1, offset
        #10;
        $display("J-Type: jal, rd = %d, imm = %d, RegWrite = %b", rd, imm, RegWrite);

        // I-Type (lw x4, 0(x5))
        instr = 32'b000000000000_00101_010_00100_0000011;  // lw x4, 0(x5)
        #10;
        $display("I-Type: lw, rs1 = %d, imm = %d, rd = %d, MemRead = %b", rs1, imm, rd, MemRead);

        // I-Type 移位指令 (slli x1, x2, 1)
        instr = 32'b0000000_00001_00010_001_00001_0010011;  // slli x1, x2, 1
        #10;
        $display("I-Type: slli, rs1 = %d, shamt = %d, rd = %d, ALUSrc = %b, RegWrite = %b", rs1, shamt, rd, ALUSrc, RegWrite);

        // I-Type 移位指令 (srli x1, x2, 1)
        instr = 32'b0000000_00001_00010_101_00001_0010011;  // srli x1, x2, 1
        #10;
        $display("I-Type: srli, rs1 = %d, shamt = %d, rd = %d, ALUSrc = %b, RegWrite = %b", rs1, shamt, rd, ALUSrc, RegWrite);

        // I-Type 移位指令 (srai x1, x2, 1)
        instr = 32'b0100000_00001_00010_101_00001_0010011;  // srai x1, x2, 1
        #10;
        $display("I-Type: srai, rs1 = %d, shamt = %d, rd = %d, ALUSrc = %b, RegWrite = %b", rs1, shamt, rd, ALUSrc, RegWrite);

        $finish;
    end
endmodule

