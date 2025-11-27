module alu(
    input  logic [31:0] A, B,
    input  logic [1:0]  ALUControl,
    output logic [31:0] ALUResult,
    output logic [3:0]  ALUFlags
);
    logic N, Z, C, V;
    logic [32:0] tmp;
    
    always_comb begin
        tmp = 33'b0;
        ALUResult = 32'b0;
        C = 1'b0;
        V = 1'b0;
        
        case (ALUControl)
            2'b00: begin // ADD
                tmp = {1'b0, A} + {1'b0, B};
                ALUResult = tmp[31:0];
                C = tmp[32];
                V = (~A[31] & ~B[31] & ALUResult[31]) | 
                    ( A[31] &  B[31] & ~ALUResult[31]);
            end
            
            2'b01: begin // SUB
                tmp = {1'b0, A} - {1'b0, B};
                ALUResult = tmp[31:0];
                C = ~tmp[32];
                V = ( A[31] & ~B[31] & ~ALUResult[31]) | 
                    (~A[31] &  B[31] &  ALUResult[31]);
            end
            
            2'b10: begin // AND
                ALUResult = A & B;
            end
            
            2'b11: begin // ORR (tambien se usa para MOV)
                ALUResult = A | B;
            end
            
            default: ALUResult = 32'b0;
        endcase
        
        N = ALUResult[31];
        Z = (ALUResult == 32'b0);
        ALUFlags = {N, Z, C, V};
    end
    
endmodule