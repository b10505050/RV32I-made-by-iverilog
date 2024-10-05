`timescale 1ns/100ps

module CPU_tb;
    reg clk;
    reg reset;
    wire [31:0] pc, instr, busA, busB;
    
    // Instantiate CPU
    CPU cpu (
        .clk(clk),
        .reset(reset)
    );

    // Monitor Signals
    assign pc = cpu.pc_reg.pc;
    assign instr = cpu.instr_mem.instr;
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
        #800;  // Adjust time as needed to cover all instructions
        $finish;
    end

    // Monitor output at each clock cycle
    initial begin
        $monitor("Time: %0t | PC: %h | Instr: %b | rs1 Data: %h | rs2 Data: %h", 
                 $time, pc, instr, busA, busB);
    end

    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars;
    end
endmodule

