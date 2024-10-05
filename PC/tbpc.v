`timescale 1ns/100ps

module PC_tb;

    reg clk;
    reg reset;
    reg [31:0] next_pc;


    wire [31:0] pc;


    PC uut (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );


    always #5 clk = ~clk;


    initial begin

        $dumpfile("PC_tb.vcd");
        $dumpvars;


        clk = 0;
        reset = 1;
        next_pc = 32'b0;

 
        #10 reset = 0;  
        #10 next_pc = 32'd4;  
        #10 next_pc = 32'd8;   
        #10 next_pc = 32'd12; 
        #10 next_pc = 32'd16;  
        #10 reset = 1;  
        #10 reset = 0;  

        #20 $finish;   
    end

endmodule

