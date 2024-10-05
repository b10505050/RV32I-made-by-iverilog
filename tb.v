`timescale 1ns/100ps

module CPU_tb;
    reg clk;
    reg reset;
    wire [31:0] pc, instr, busA, busB, imm, alu_result, mem_data;
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

    // Initialize signals for testing
    initial begin
        clk = 0;
        reset = 1;
        #10 reset = 0;

        // Pre-set register values for x2 and x3 for the add operation
        cpu.reg_file.registers[2] = 10; // x2 = 10
        cpu.reg_file.registers[3] = 20; // x3 = 20

        #500;
        $finish;
    end

    // Generate clock
    always #5 clk = ~clk;

    // Monitor outputs for debugging
    initial begin
        $monitor("Time: %0t | PC: %h | Instr: %h | rs1: %h | rs2: %h | rd: %h | funct3: %h | funct7: %h | ALUOp: %b | busA: %h | busB: %h | ALU Result: %h | Mem Data: %h",
                 $time, cpu.pc_reg.pc, cpu.instr_mem.instr, cpu.decoder.rs1, cpu.decoder.rs2, cpu.decoder.rd, cpu.decoder.funct3, cpu.decoder.funct7, cpu.decoder.ALUOp, cpu.reg_file.busA, cpu.reg_file.busB, cpu.alu.Result, cpu.data_mem.read_data);
    end

    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars;
    end
endmodule

