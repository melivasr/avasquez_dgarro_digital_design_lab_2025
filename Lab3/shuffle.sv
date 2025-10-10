module shuffle(
    input  logic       clk,
    input  logic       rst,          
    input  logic       init_board,   
    input  logic       start,        
    input  logic [3:0] init,         
    output logic       done,         
    output logic [3:0] board [0:15]
);
  
    logic [7:0] rnd8;
    random rng(.clk(clk), .rst(rst), .seed({4'hB, init}), .rnd(rnd8));

    logic [4:0] j;        
    logic       busy;
    logic       start_d;
    logic       start_rise;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) start_d <= 1'b0;
        else     start_d <= start;
    end
    assign start_rise = start & ~start_d;

    logic [3:0] k;        
   

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // NO modificar 'board' en reset
            j    <= 5'd0;
            busy <= 1'b0;
            done <= 1'b0;
        end else begin
            if (init_board) begin
                board <= '{
                    4'd0,4'd0, 4'd1,4'd1, 4'd2,4'd2, 4'd3,4'd3,
                    4'd4,4'd4, 4'd5,4'd5, 4'd6,4'd6, 4'd7,4'd7
                };
                j    <= 5'd0;
                busy <= 1'b0;
                done <= 1'b0;
            end
            else if (start_rise && !busy) begin
               
                j    <= 5'd15;
                busy <= 1'b1;
                done <= 1'b0;
            end
            else if (busy) begin
                // índice aleatorio en [0..j]
                k <= (j == 0) ? 4'd0 : (rnd8 % (j + 5'd1));

                // swap board[j] <-> board[k]
                {board[j[3:0]], board[k]} <= {board[k], board[j[3:0]]};

                // siguiente paso
                if (j == 5'd0) begin
                    busy <= 1'b0;
                    done <= 1'b1;    
                end else begin
                    j <= j - 5'd1;
                end
            end
        end
    end
endmodule
