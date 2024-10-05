module ALU (
    input [31:0] A,           
    input [31:0] B,           
    input [1:0] ALUOp,        
    input [2:0] funct3,       
    input [4:0] shamt,        
    input [6:0] funct7,      
    output reg [31:0] Result, 
    output Zero,
    output reg Less               
);

    assign Zero = (Result == 32'b0);

    always @(*) begin
        Less = ($signed(A) < $signed(B)) ? 1'b1 : 1'b0;
        
        case (ALUOp)
            2'b00: begin // 算術運算類型
                case (funct3)
                    3'b000: begin // ADD 或 SUB
                        if (funct7 == 7'b0100000)
                            Result = A - B;  // 减法
                        else
                            Result = A + B;  // 加法
                    end
                    3'b100: Result = A ^ B;  // XOR
                    3'b110: Result = A | B;  // OR
                    3'b111: Result = A & B;  // AND
                    default: Result = 32'b0;
                endcase
            end
            2'b01: begin // 移位操作
                case (funct3)
                    3'b001: Result = A << shamt;       // SLL 左移
                    3'b101: begin
                        if (funct7 == 7'b0100000)
                            Result = $signed(A) >>> shamt; // SRA 算術右移
                        else
                            Result = A >> shamt;         // SRL 邏輯右移
                    end
                    default: Result = 32'b0;
                endcase
            end
            2'b10: begin // 比較操作
                case (funct3)
                    3'b010: Result = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLT 有符號比較
                    3'b011: Result = (A < B) ? 32'b1 : 32'b0;                   // SLTU 無符號比較
                    default: Result = 32'b0;
                endcase
            end
            default: Result = 32'b0;
        endcase
    end

endmodule
