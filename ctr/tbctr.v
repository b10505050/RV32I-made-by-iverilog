`timescale 1ns/100ps

module ControlUnit_tb;
    reg [6:0] opcode;
    reg [2:0] funct3;
    reg [6:0] funct7;

    wire RegWrite;
    wire MemWrite;
    wire MemRead;
    wire MemToReg;
    wire ALUSrc;
    wire Branch;
    wire Jump;
    wire [1:0] ALUOp;


    ControlUnit uut (
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .RegWrite(RegWrite),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .MemToReg(MemToReg),
        .ALUSrc(ALUSrc),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );

    initial begin

        $dumpfile("ControlUnit_tb.vcd");
        $dumpvars;


        opcode = 7'b0000000;
        funct3 = 3'b000;
        funct7 = 7'b0000000;
        #10;

        // R-Type  (add, sub)
        opcode = 7'b0110011;  // R-Type
        funct3 = 3'b000;      // add
        funct7 = 7'b0000000;  // add
        #10;
        $display("R-Type Add: RegWrite = %b, ALUOp = %b", RegWrite, ALUOp);

        // I-Type load 
        opcode = 7'b0000011;  // I-Type (load)
        funct3 = 3'b010;      // lw
        #10;
        $display("I-Type Load: MemRead = %b, MemToReg = %b, ALUSrc = %b", MemRead, MemToReg, ALUSrc);

        //  S-Type store
        opcode = 7'b0100011;  // S-Type (store)
        funct3 = 3'b010;      // sw
        #10;
        $display("S-Type Store: MemWrite = %b, ALUSrc = %b", MemWrite, ALUSrc);

        //  B-Type branch 
        opcode = 7'b1100011;  // B-Type (branch)
        funct3 = 3'b000;      // beq
        #10;
        $display("B-Type Branch: Branch = %b, ALUOp = %b", Branch, ALUOp);

        //J-Type jump (jal)
        opcode = 7'b1101111;  // J-Type (jal)
        #10;
        $display("J-Type Jump: Jump = %b", Jump);

        // J-Type jump  (jalr)
        opcode = 7'b1100111;  // J-Type (jalr)
        #10;
        $display("J-Type Jump (jalr): Jump = %b", Jump);

        $finish;
    end
endmodule

