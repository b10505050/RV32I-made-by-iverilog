`timescale 1ns/100ps

module CPU (
    input wire clk,
    input wire reset
);

    wire [31:0] pc, next_pc, instr, busA, busB;
    wire [4:0] rs1, rs2, rd;

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

    // Extract fields from instruction
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];
    assign rd  = instr[11:7];

    // Register File
    register_file reg_file (
        .Ra(rs1),
        .Rb(rs2),
        .Rw(rd),
        .busW(32'd0),      // 暫時設為0，無寫入操作
        .RegWr(1'b0),      // 暫時設為0，無寫入操作
        .WrClk(clk),
        .busA(busA),
        .busB(busB)
    );

    // 簡單的PC更新邏輯
    assign next_pc = pc + 4; // PC每次加4以擷取下一條指令

endmodule

