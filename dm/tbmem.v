`timescale 1ns/100ps

module DataMemory_tb;
    reg clk;
    reg MemRead;
    reg MemWrite;
    reg [31:0] addr;
    reg [31:0] write_data;
    wire [31:0] read_data;


    DataMemory uut (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .addr(addr),
        .write_data(write_data),
        .read_data(read_data)
    );


    always #5 clk = ~clk;

    initial begin
        $dumpfile("DM.vcd");
        $dumpvars;

        clk = 0;
        MemRead = 0;
        MemWrite = 0;
        addr = 32'b0;
        write_data = 32'b0;

        // Test 1: write in x0
        #10;
        MemWrite = 1;        
        addr = 32'h00000000; 
        write_data = 32'hDEADBEEF; 
        #10;
        MemWrite = 0;        

        // Test 2: read x0
        #10;
        MemRead = 1;         
        addr = 32'h00000000; 
        #10;
        $display("Test 2: Read Data at Addr 0 = %h", read_data);
        MemRead = 0;      

        // Test 3: write x4
        #10;
        MemWrite = 1;        
        addr = 32'h00000004; 
        write_data = 32'h12345678; 
        #10;
        MemWrite = 0;       

        // Test 4: read x4
        #10;
        MemRead = 1;         
        addr = 32'h00000004;
        #10;
        $display("Test 4: Read Data at Addr 4 = %h", read_data);
        MemRead = 0;         

        // Test 5: read x8
        #10;
        MemRead = 1;        
        addr = 32'h00000008; 
        #10;
        $display("Test 5: Read Data at Addr 8 = %h (should be 0)", read_data);
        MemRead = 0;         

        $finish;
    end
endmodule

