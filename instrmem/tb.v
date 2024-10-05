`timescale 1ns/100ps

module Instr_Mem_tb;
    reg [31:0] addr;         // 地址信號
    wire [31:0] instr;       // 指令輸出

    // 實例化 Instr_Mem 模組
    Instr_Mem uut (
        .addr(addr),
        .instr(instr)
    );

    // 初始化
    initial begin
        // 設置 VCD 文件，用於波形查看
        $dumpfile("Instr_Mem_tb.vcd");
        $dumpvars(0, Instr_Mem_tb);

        // 多週期指令測試，模擬複雜運算並觀察指令的順序和結果
        // 第一次指令：加法運算
        addr = 0; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: add x1, x2, x3", $time, addr, instr);

        // 第二次指令：減法運算
        addr = 4; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: sub x1, x2, x3", $time, addr, instr);

        // 第三次指令：異或運算
        addr = 8; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: xor x1, x2, x3", $time, addr, instr);

        // 第四次指令：或運算
        addr = 12; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: or x1, x2, x3", $time, addr, instr);

        // 第五次指令：位移操作
        addr = 20; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: sll x1, x2, x3", $time, addr, instr);

        // 第六次指令：條件跳轉
        addr = 40; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: beq x1, x2, offset", $time, addr, instr);

        // 測試 I-type 指令加上立即數
        addr = 10; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: addi x1, x2, imm", $time, addr, instr);

        // 測試讀取指令並執行讀取與存儲
        addr = 34; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: lw x4, 0(x5)", $time, addr, instr);

        addr = 35; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: sw x1, 0(x2)", $time, addr, instr);

        // 測試 pseudo 指令
        addr = 37; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: nop", $time, addr, instr);

        addr = 39; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: li x1, 0", $time, addr, instr);

        // 測試跳轉指令
        addr = 27; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: jal x1, offset", $time, addr, instr);

        addr = 28; #10;
        $display("Time: %0t | Addr: %h | Instr: %h | Expect: jalr x2, x1, offset", $time, addr, instr);

        // 確認測試範圍內所有指令
        $finish;
    end
endmodule

