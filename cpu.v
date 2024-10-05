`timescale 1ns/100ps

module CPU (
    input wire clk,
    input wire reset
);

    wire [31:0] pc, next_pc, instr, imm, busA, busB, alu_result, mem_data;
    wire [4:0] rs1, rs2, rd, shamt;
    wire [2:0] funct3;
    wire [6:0] funct7, opcode;
    wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch, Jump;
    wire [1:0] ALUOp;
    wire Zero, Less;

    // PC
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
        .busW(mem_data),
        .RegWr(RegWrite),
        .WrClk(clk),
        .busA(busA),
        .busB(busB)
    );

    // ALU
    ALU alu (
        .A(busA),
        .B(ALUSrc ? imm : busB),
        .ALUOp(ALUOp),
        .funct3(funct3),
        .shamt(shamt),
        .funct7(funct7),
        .Result(alu_result),
        .Zero(Zero),
        .Less(Less)
    );

    // Data Memory
    DataMemory data_mem (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(alu_result),
        .write_data(busB),
        .read_data(mem_data)
    );

    // PC Update Logic
    assign next_pc = (Jump) ? alu_result : ((Branch && Zero) ? (pc + imm) : (pc + 4));

endmodule
