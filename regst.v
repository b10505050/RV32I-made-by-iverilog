`timescale 1ns/100ps


module register_file (
    input wire [4:0] Ra,       //r1
    input wire [4:0] Rb,       //r2
    input wire [4:0] Rw,       // rd
    input wire [31:0] busW,    // data write 1
    input wire RegWr,          // enable
    input wire WrClk,          // clk
    output wire [31:0] busA,   // data read 1
    output wire [31:0] busB    // data read 2
);

    // 32條32位元的reg
    reg [31:0] registers [31:0];

    // 讀取reg x0~x31? (使用條件運算子 a = (b)?c:d >> if b = 1 a = c / b = 0 a = d)
    assign busA = (Ra == 5'b0) ? 32'b0 : registers[Ra];  // x0常數限制
    assign busB = (Rb == 5'b0) ? 32'b0 : registers[Rb];  // x0常數限制

    // 寫入於下降寫入
    always @(negedge WrClk) begin
        if (RegWr && Rw ) begin  
            registers[Rw] <= busW;
        end
    end


    // 初始化寄存器为0
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registers[i] = 32'b0;
        end
    end
endmodule

