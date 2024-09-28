`timescale 1ns/100ps

module Instr_Mem_tb;
    reg [31:0] addr;

    
    wire [31:0] instr;  

  
    Instr_Mem uut (
        .addr(addr),
        .instr(instr)
    );

  
    integer i;  

    initial begin
        $dumpfile("instr.vcd");
        $dumpvars;

        for (i = 0; i < 42; i = i + 1) begin
            addr = i * 4;  
            #10;           
            $display("Test %0d: Addr = %0d, Instr = %b", i + 1, addr, instr);
        end

        $finish;
    end
endmodule

