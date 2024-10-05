`timescale 1ns/100ps

module CPU_tb;
    reg clk;
    reg reset;
    wire [31:0] pc, instr, busA, busB, imm;
    wire [4:0] rs1, rs2, rd, shamt;
    wire [2:0] funct3;
    wire [6:0] funct7, opcode;
    wire RegWrite, MemRead, MemWrite, MemToReg, ALUSrc, Branch, Jump;
    wire [1:0] ALUOp;

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

    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;
        #10;
        
        reset = 0;  // release reset

        // Test with multiple clock cycles
        #1000;  // Adjust time as needed to cover all instructions
        $finish;
    end

    // Monitor output at each clock cycle
    initial begin
        $monitor("Time: %0t | PC: %b | Instr: %b | rs1: %h | rs2: %h | rd: %h | funct3: %h | funct7: %h | opcode: %h | imm: %h | shamt: %h | RegWrite: %b | MemRead: %b | MemWrite: %b | ALUSrc: %b | Branch: %b | Jump: %b | ALUOp: %b | busA: %h | busB: %h", 
                 $time, pc, instr, rs1, rs2, rd, funct3, funct7, opcode, imm, shamt, RegWrite, MemRead, MemWrite, ALUSrc, Branch, Jump, ALUOp, busA, busB);
    end

    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars;
    end
endmodule

