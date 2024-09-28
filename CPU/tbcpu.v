`timescale 1ns/100ps

module CPU_tb;
    reg clk;
    reg reset;


    CPU cpu (
        .clk(clk),
        .reset(reset)
    );


    always #5 clk = ~clk;

    initial begin
 
        clk = 0;
        reset = 1;
        #10;
        reset = 0; 

      
        #500;

  
        $finish;
    end

    initial begin
 
        $dumpfile("CPU_tb.vcd");
        $dumpvars;


        $monitor("Time: %0t, PC: %h, Instr: %h", $time, cpu.pc, cpu.instr);
    end
endmodule

