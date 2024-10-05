`timescale 1ns/100ps

module register_file (
    input wire [4:0] Ra,       // rs1
    input wire [4:0] Rb,       // rs2
    input wire [4:0] Rw,       // rd
    input wire [31:0] busW,    // data write
    input wire RegWr,          // enable
    input wire WrClk,          // clk
    output wire [31:0] busA,   // data read 1
    output wire [31:0] busB,   // data read 2
    output wire [31:0] reg1,   // observe register x1
    output wire [31:0] reg2    // observe register x2
);

    // 32條32位元的寄存器
    reg [31:0] registers [31:0];

    // 讀取寄存器 x0~x31
    assign busA = (Ra == 5'b0) ? 32'b0 : registers[Ra];  // x0 永遠為 0
    assign busB = (Rb == 5'b0) ? 32'b0 : registers[Rb];  // x0 永遠為 0

    // x1 和 x2 的額外輸出端口，用於觀察其值
    assign reg1 = registers[1];
    assign reg2 = registers[2];

    // 在時鐘的下降沿進行寫入操作
    always @(negedge WrClk) begin
        if (RegWr && (Rw != 5'b0)) begin  // x0 無法寫入
            registers[Rw] <= busW;
        end
    end

    // 初始化寄存器為 0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end
endmodule

