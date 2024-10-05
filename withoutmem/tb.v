`timescale 1ns/100ps

module CPU_tb;
    reg clk;
    reg reset;
    wire [31:0] pc, instr, busA, busB, imm, alu_result;
    wire [4:0] rs1, rs2, rd, shamt;
    wire [2:0] funct3;
    wire [6:0] funct7, opcode;
    wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch, Jump;
    wire [1:0] ALUOp;
    wire Zero, Less;

    // Instantiate CPU
    CPU cpu (
        .clk(clk),
        .reset(reset)
    );

    // Assign signals for monitoring
    assign pc = cpu.pc_reg.pc;
    assign instr = cpu.instr_mem.instr;
    assign rs1 = cpu.decoder.rs1;
    assign rs2 = cpu.decoder.rs2;
    assign rd = cpu.decoder.rd;
    assign funct3 = cpu.decoder.funct3;
    assign funct7 = cpu.decoder.funct7;
    assign opcode = cpu.decoder.opcode;
    assign imm = cpu.decoder.imm;
    assign shamt = cpu.decoder.shamt;
    assign RegWrite = cpu.decoder.RegWrite;
    assign MemRead = cpu.decoder.MemRead;
    assign MemWrite = cpu.decoder.MemWrite;
    assign MemToReg = cpu.decoder.MemToReg;
    assign ALUSrc = cpu.decoder.ALUSrc;
    assign Branch = cpu.decoder.Branch;
    assign Jump = cpu.decoder.Jump;
    assign ALUOp = cpu.decoder.ALUOp;
    assign busA = cpu.reg_file.busA;
    assign busB = cpu.reg_file.busB;
    assign alu_result = cpu.alu.Result;

    // Initialize register values for testing
    initial begin
        clk = 1;
        reset = 1;
        #1
        reset = 0;
        
        // Set initial register values for testing
        cpu.reg_file.registers[2] = 10; // x2 = 10
        cpu.reg_file.registers[3] = 20; // x3 = 20

        #200;
        $finish;
    end

    // Clock Generation
    always #5 clk = ~clk;

    // Monitor output at each clock cycle
    initial begin
        $monitor("Time: %0t | PC: %h | Instr: %h | rs1: %h | rs2: %h | rd: %h | funct3: %h | funct7: %h | opcode: %h | imm: %h | shamt: %h | RegWrite: %b | MemRead: %b | MemWrite: %b | ALUSrc: %b | Branch: %b | Jump: %b | ALUOp: %b | busA: %h | busB: %h | ALU Result: %h", 
                 $time, pc, instr, rs1, rs2, rd, funct3, funct7, opcode, imm, shamt, RegWrite, MemRead, MemWrite, ALUSrc, Branch, Jump, ALUOp, busA, busB, alu_result);
    end

    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars;
    end
endmodule

