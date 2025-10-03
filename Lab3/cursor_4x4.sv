module cursor_4x4 #(
    parameter int GRID_COLS = 4,
    parameter int GRID_ROWS = 4
)(
    input  logic clk,
    input  logic rst,
    input  logic enable,         
    input  logic up_pulse,
    input  logic down_pulse,
    input  logic left_pulse,
    input  logic right_pulse,
    output logic [$clog2(GRID_ROWS)-1:0] sel_row,
    output logic [$clog2(GRID_COLS)-1:0] sel_col,
    output logic [5:0] sel_idx            
);
    localparam int RW = $clog2(GRID_ROWS);
    localparam int CW = $clog2(GRID_COLS);

    // posición actual
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sel_row <= '0; // arranca en (0,0)
            sel_col <= '0;
        end else if (enable) begin

            if (up_pulse) begin
                sel_row <= (sel_row == 0) ? GRID_ROWS-1 : sel_row - 1;
            end
            if (down_pulse) begin
                sel_row <= (sel_row == GRID_ROWS-1) ? 0 : sel_row + 1;
            end
            if (left_pulse) begin
                sel_col <= (sel_col == 0) ? GRID_COLS-1 : sel_col - 1;
            end
            if (right_pulse) begin
                sel_col <= (sel_col == GRID_COLS-1) ? 0 : sel_col + 1;
            end
        end
    end

    always_comb begin
        sel_idx = sel_row * GRID_COLS + sel_col;
    end
endmodule
