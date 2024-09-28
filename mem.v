`timescale 1ns/100ps

module DataMemory (
    input wire clk,                
    input wire MemRead,            
    input wire MemWrite,           
    input wire [31:0] addr,        
    input wire [31:0] write_data,  
    output reg [31:0] read_data    
);

    reg [31:0] memory [0:65535];  
    integer i;
    initial begin
        for (i = 0; i < 65536; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end
    always @(negedge clk) begin
        if (MemWrite) begin
            memory[addr[15:0] >> 2] <= write_data;  
        end
    end
    always @(posedge clk) begin
        if (MemRead) begin
            read_data <= memory[addr[15:0] >> 2];   
        end
    end
endmodule

