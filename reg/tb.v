`timescale 1ns/100ps

module DataMemory_tb;
    reg clk;
    reg MemRead;
    reg MemWrite;
    reg [31:0] addr;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // 實例化 DataMemory 模組
    DataMemory uut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // 時鐘產生
    always #5 clk = ~clk;

    // 初始化信號
    initial begin
        clk = 0;
        MemRead = 0;
        MemWrite = 0;
        addr = 32'b0;
        write_data = 32'b0;

        // 第一個寫入操作
        #10;
        MemWrite = 1;
        addr = 32'd4;          // 地址4
        write_data = 32'd100;  // 寫入100
        #10;
        MemWrite = 0;          // 停止寫入

        // 第二個寫入操作
        #10;
        MemWrite = 1;
        addr = 32'd8;          // 地址8
        write_data = 32'd200;  // 寫入200
        #10;
        MemWrite = 0;          // 停止寫入

        // 第一次讀取操作
        #10;
        MemRead = 1;
        addr = 32'd4;          // 讀取地址4
        #10;
        MemRead = 0;

        // 第二次讀取操作
        #10;
        MemRead = 1;
        addr = 32'd8;          // 讀取地址8
        #10;
        MemRead = 0;

        // 第三次寫入操作
        #10;
        MemWrite = 1;
        addr = 32'd12;         // 地址12
        write_data = 32'd300;  // 寫入300
        #10;
        MemWrite = 0;

        // 第三次讀取操作
        #10;
        MemRead = 1;
        addr = 32'd12;         // 讀取地址12
        #10;
        MemRead = 0;

        // 顯示結果並結束模擬
        #10;
        $finish;
    end

    // 顯示信號變化
    initial begin
        $monitor("Time: %0t | MemWrite: %0b | MemRead: %0b | Addr: %h | Write Data: %h | Read Data: %h",
                 $time, MemWrite, MemRead, addr, write_data, read_data);
    end

    initial begin
        $dumpfile("DataMemory_tb.vcd");
        $dumpvars;
    end
endmodule

