`timescale 1ns/100ps

module Decoder (
    input [31:0] instr,           
    output reg [4:0] rs1,         
    output reg [4:0] rs2,         
    output reg [4:0] rd,          
    output reg [2:0] funct3,      
    output reg [6:0] funct7,      
    output reg [6:0] opcode,      
    output reg [31:0] imm,        
    output reg [4:0] shamt,       
    output reg RegWrite,          
    output reg MemRead,           
    output reg MemWrite,          
    output reg MemToReg,          
    output reg ALUSrc,            
    output reg Branch,            
    output reg Jump,              
    output reg [1:0] ALUOp        
);

    always @(*) begin
        // Extract fields from the instruction
        opcode = instr[6:0];
        rd = instr[11:7];
        funct3 = instr[14:12];
        rs1 = instr[19:15];
        rs2 = instr[24:20];
        funct7 = instr[31:25];

        // Default values
        shamt = instr[24:20];  
        imm = 32'b0;
        RegWrite = 0;
        MemRead = 0;
        MemWrite = 0;
        MemToReg = 0;
        ALUSrc = 0;
        Branch = 0;
        Jump = 0;
        ALUOp = 2'b00;

        case (opcode)
            7'b0110011: begin // R-Type (e.g., add, sub, and, or)
                RegWrite = 1;
                ALUSrc = 0;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                ALUOp = 2'b10;
            end
            7'b0010011: begin // I-Type for ALU immediate (e.g., addi, slli)
                RegWrite = 1;
                ALUSrc = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                ALUOp = 2'b11;
                imm = {{20{instr[31]}}, instr[31:20]};
                if (funct3 == 3'b001 || funct3 == 3'b101) begin // Shift instructions with immediate
                    shamt = instr[24:20];
                end
            end
            7'b0000011: begin // I-Type Load (e.g., lw, lb)
                RegWrite = 1;
                ALUSrc = 1;
                MemToReg = 1;
                MemRead = 1;
                MemWrite = 0;
                Branch = 0;
                ALUOp = 2'b00;
                imm = {{20{instr[31]}}, instr[31:20]};
            end
            7'b0100011: begin // S-Type Store (e.g., sw, sb)
                RegWrite = 0;
                ALUSrc = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 1;
                Branch = 0;
                ALUOp = 2'b00;
                imm = {{20{instr[31]}}, instr[31:25], instr[11:7]};
            end
            7'b1100011: begin // B-Type Branch (e.g., beq, bne)
                RegWrite = 0;
                ALUSrc = 0;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 1;
                ALUOp = 2'b01;
                imm = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
            end
            7'b1101111: begin // J-Type Jump (e.g., jal)
                RegWrite = 1;
                ALUSrc = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                Jump = 1;
                ALUOp = 2'b00;
                imm = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
            end
            7'b1100111: begin // I-Type Jump Register (e.g., jalr)
                RegWrite = 1;
                ALUSrc = 1;
                MemToReg = 0;
                MemRead = 0;
                MemWrite = 0;
                Branch = 0;
                Jump = 1;
                ALUOp = 2'b00;
                imm = {{20{instr[31]}}, instr[31:20]};
            end
            default: begin
                RegWrite = 0;
                MemRead = 0;
                MemWrite = 0;
                MemToReg = 0;
                ALUSrc = 0;
                Branch = 0;
                Jump = 0;
                ALUOp = 2'b00;
                imm = 32'b0;
                shamt = 5'b0;
            end
        endcase
    end

endmodule

