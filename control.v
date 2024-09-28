module ControlUnit (
    input wire [6:0] opcode,       
    input wire [2:0] funct3,      
    input wire [6:0] funct7,       
    output reg RegWrite,           
    output reg MemWrite,        
    output reg MemRead,          
    output reg MemToReg,        
    output reg ALUSrc,            
    output reg Branch,            
    output reg Jump,               
    output reg [1:0] ALUOp       
);

    always @(*) begin
        RegWrite = 0;
        MemWrite = 0;
        MemRead = 0;
        MemToReg = 0;
        ALUSrc = 0;
        Branch = 0;
        Jump = 0;
        ALUOp = 2'b00;

        case (opcode)
            7'b0110011: begin  // R-Type (add, sub, etc.)
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUSrc = 0;
                Branch = 0;
                ALUOp = 2'b10;  // ALU operation (determined by funct3 and funct7)
            end
            7'b0000011: begin  // I-Type (load)
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 1;
                MemToReg = 1;
                ALUSrc = 1;
                Branch = 0;
                ALUOp = 2'b00;  // ALU operation (add for address calculation)
            end
            7'b0100011: begin  // S-Type (store)
                RegWrite = 0;
                MemWrite = 1;
                MemRead = 0;
                MemToReg = 0;
                ALUSrc = 1;
                Branch = 0;
                ALUOp = 2'b00;  // ALU operation (add for address calculation)
            end
            7'b1100011: begin  // B-Type (branch)
                RegWrite = 0;
                MemWrite = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUSrc = 0;
                Branch = 1;
                ALUOp = 2'b01;  // ALU operation (sub for comparison)
            end
            7'b1101111: begin  // J-Type (jal)
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUSrc = 0;
                Branch = 0;
                Jump = 1;     
                ALUOp = 2'b00; 
            end
            7'b1100111: begin  // J-Type (jalr)
                RegWrite = 1;
                MemWrite = 0;
                MemRead = 0;
                MemToReg = 0;
                ALUSrc = 1;
                Branch = 0;
                Jump = 1;    
                ALUOp = 2'b00;  
            end
            default: begin

            end
        endcase
    end
endmodule

