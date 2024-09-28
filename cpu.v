`timescale 1ns/100ps
module CPU (
    input wire clk,
    input wire reset
);

    wire [31:0] pc, next_pc, instr, imm;
    wire [31:0] busA, busB, alu_result, mem_data;
    wire [4:0] rs1, rs2, rd;
    wire [1:0] ALUOp;
    wire RegWrite, MemWrite, MemRead, MemToReg, ALUSrc, Branch, Jump, Zero, Less;

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

    // Instruction Decode (extract fields from instr)
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd  = instr[11:7];
    assign imm ={{20{instr[31]}}, instr[31:20]};
//*************************************************
    // Control Unit
    ControlUnit control (
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );

    // Register File
    register_file reg_file (
        .WrClk(clk),
        .RegWr(RegWrite),
        .Ra(rs1),
        .Rb(rs2),
        .Rw(rd),
        .busW(mem_data), 
        .busA(busA),
        .busB(busB)
    );

    // ALU
 ALU alu (
    .A(busA),
    .B(ALUSrc ? imm : busB),
    .ALUOp(ALUOp),
    .shamt(instr[24:20]),         
    .funct7(instr[31:25]),       
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
    assign next_pc = (Jump) ? alu_result : ((Branch && Zero) ?  (pc + imm)  : (pc + 4));

endmodule

