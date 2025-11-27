module score_manager_two (
    input  logic clk,
    input  logic rst,
    input  logic clr_scores,     // limpia a 0 ambos puntajes
    input  logic inc_score,      // pulso de 1 clk para sumar
    input  logic player,         // 0 = J0, 1 = J1
    output logic [3:0] score_p0, // 0..8
    output logic [3:0] score_p1  // 0..8
);
    // arranque y reset en 0
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            score_p0 <= 4'd0;
            score_p1 <= 4'd0;
        end else if (clr_scores) begin
            score_p0 <= 4'd0;
            score_p1 <= 4'd0;
        end else begin
            // incrementar solo al jugador activo
            if (inc_score) begin
                if (player == 1'b0) begin
                    score_p0 <= (score_p0 < 4'd8) ? (score_p0 + 4'd1) : 4'd8;
                end else begin
                    score_p1 <= (score_p1 < 4'd8) ? (score_p1 + 4'd1) : 4'd8;
                end
            end
        end
    end
endmodule
