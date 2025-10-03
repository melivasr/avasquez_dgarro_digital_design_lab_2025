module shuffle(
    input  logic clk,
    input  logic rst,
    input  logic start,          // random_enable para la FSM
    input  logic [3:0] init,     // Posición inicial
    output logic done,           // Termina
    output logic [3:0] board [0:15]
);

    logic [3:0] rnd;
    int j;
	 int idx;

    random rng(.clk(clk), .rst(rst), .init(init), .rnd(rnd));

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            done <= 0;
            j    <= 0;
            // Tablero inicial fijo (pares 0–7)
            board <= '{
                4'd0, 4'd0,
                4'd1, 4'd1,
                4'd2, 4'd2,
                4'd3, 4'd3,
                4'd4, 4'd4,
                4'd5, 4'd5,
                4'd6, 4'd6,
                4'd7, 4'd7
            };
        end 
		  else if (start && !done) begin
            // Intercambio de las posiciones de to
            idx = rnd % 16;
            {board[j], board[idx]} <= {board[idx], board[j]};

            j <= j + 1;

            if (j == 15) done <= 1;
        end
    end
endmodule
