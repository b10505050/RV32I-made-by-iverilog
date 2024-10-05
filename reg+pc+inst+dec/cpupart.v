`timescale 1ns/100ps

module CPU (
    input wire clk,
    input wire reset
);

    wire [31:0] pc, next_pc, instr, busA, busB, imm;
    wire [4:0] rs1, rs2, rd, shamt;
    wire [2:0] funct3;
    wire [6:0] funct7, opcode;
    wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch, Jump;
    wire [1:0] ALUOp;

    // Program Counter (PC)
    PC pc_reg (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    // Instruction Memory
    Instr_Mem instr_mem (
        .addr(pc),
        .instr(instr)
    );

    // Decoder
    Decoder decoder (
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
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );

    // Register File
    register_file reg_file (
        .Ra(rs1),
        .Rb(rs2),
        .Rw(rd),
        .busW(32'd0),      
        .RegWr(RegWrite),  
        .WrClk(clk),
        .busA(busA),
        .busB(busB)
    );

    // PC Update Logic
    assign next_pc = pc + 4; // PC increment by 4 for next instruction

endmodule

