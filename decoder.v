`timescale 1ns/100ps

module Decoder(
    input [31:0] instr,            // 输入的32位指令
    output reg [4:0] rs1,           // 源寄存器1 (rs1)
    output reg [4:0] rs2,           // 源寄存器2 (rs2)
    output reg [4:0] rd,            // 目标寄存器 (rd)
    output reg [2:0] funct3,        // 功能码 (funct3)
    output reg [6:0] funct7,        // 功能码 (funct7)
    output reg [6:0] opcode,        // 操作码 (opcode)
    output reg [31:0] imm,          // 立即数 (imm)
    output reg [4:0] shamt,         // 移位量 (shamt)

    // 控制信号输出
    output reg RegWrite,            // 寄存器写使能
    output reg MemRead,             // 内存读使能
    output reg MemWrite,            // 内存写使能
    output reg MemtoReg,            // 内存数据写入寄存器
    output reg ALUSrc,              // ALU输入来源（立即数或寄存器）
    output reg Branch,              // 跳转信号
    output reg [1:0] ALUOp          // ALU操作码
);

    always @(*) begin
        // 解析指令字段
        opcode = instr[6:0];       // opcode 在指令的第[6:0]位
        rd     = instr[11:7];      // 目标寄存器rd 在第[11:7]位
        funct3 = instr[14:12];     // 功能码funct3 在第[14:12]位
        rs1    = instr[19:15];     // 源寄存器1 rs1 在第[19:15]位
        rs2    = instr[24:20];     // 源寄存器2 rs2 在第[24:20]位
        funct7 = instr[31:25];     // 功能码funct7 在第[31:25]位

        // 默认 shamt 和 立即数
        shamt = 5'b0;
        imm = 32'b0;

        // 默认控制信号
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        MemtoReg = 0;
        ALUSrc = 0;
        Branch = 0;
        ALUOp = 2'b00;

        // 解码器中的指令分类
        case(opcode)
            7'b0110011: begin  // R-Type 指令 (add, sub, xor, and, or, sll, srl, sra, slt, sltu)
                RegWrite = 1;
                ALUSrc = 0;    // ALU 的输入来自寄存器
                MemtoReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                ALUOp = 2'b10; // 生成ALU操作码
            end
            7'b0010011: begin  // I-Type 算术指令 (addi, xori, andi, ori, slti, sltiu)
                RegWrite = 1;
                ALUSrc = 1;    // ALU 的输入来自立即数
                MemtoReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                ALUOp = 2'b11; // 立即数操作
                imm = {{20{instr[31]}}, instr[31:20]};  // I-Type 的立即数
            end
            7'b0010011: begin  // I-Type 移位指令 (slli, srli, srai)
                if (funct3 == 3'b001 || funct3 == 3'b101) begin
                    RegWrite = 1;
                    ALUSrc = 1;    // ALU 的输入来自 shamt
                    MemtoReg = 0;
                    MemRead = 0;
                    MemWrite = 0;
                    Branch = 0;
                    ALUOp = 2'b11; // 移位操作
                    shamt = instr[24:20]; // 移位量 shamt
                end else begin
                    // 非移位的I-type指令（如 addi, ori 等）
                    imm = {{20{instr[31]}}, instr[31:20]};
                end
            end
            7'b0000011: begin  // I-Type 负载指令 (lw, lb, lh, lbu, lhu)
                RegWrite = 1;
                ALUSrc = 1;    // ALU 的输入来自立即数（地址偏移量）
                MemtoReg = 1;  // 内存数据写回寄存器
                MemRead = 1;
                MemWrite = 0;
                Branch = 0;
                ALUOp = 2'b00; // 生成地址
                imm = {{20{instr[31]}}, instr[31:20]};  // I-Type 的立即数
            end
            7'b0100011: begin  // S-Type 存储指令 (sw, sb, sh)
                RegWrite = 0;
                ALUSrc = 1;    // ALU 的输入来自立即数（地址偏移量）
                MemtoReg = 0;
                MemRead = 0;
                MemWrite = 1;
                Branch = 0;
                ALUOp = 2'b00; // 生成地址
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};  // S-Type 的立即数
            end
            7'b1100011: begin  // B-Type 分支跳转指令 (beq, bne, blt, bge, bltu, bgeu)
                RegWrite = 0;
                ALUSrc = 0;    // ALU 的输入来自寄存器
                MemtoReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 1;    // 启用分支跳转
                ALUOp = 2'b01; // 比较操作
                imm = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};  // B-Type 的立即数
            end
            7'b1101111: begin  // J-Type 跳转指令 (jal)
                RegWrite = 1;
                ALUSrc = 1;    // ALU 的输入来自立即数（跳转目标地址）
                MemtoReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;    // 直接跳转
                ALUOp = 2'b00; // 直接跳转
                imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};  // J-Type 的立即数
            end
            7'b1100111: begin  // I-Type 跳转指令 (jalr)
                RegWrite = 1;
                ALUSrc = 1;    // ALU 的输入来自立即数（跳转目标地址）
                MemtoReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;    // 直接跳转
                ALUOp = 2'b00; // 直接跳转
                imm = {{20{instr[31]}}, instr[31:20]};  // I-Type 的立即数
            end
            default: begin
                // 默认情况下所有控制信号保持为 0
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                MemtoReg = 0;
                ALUSrc = 0;
                Branch = 0;
                ALUOp = 2'b00;
                imm = 32'b0;
                shamt = 5'b0;
            end
        endcase
    end

endmodule

