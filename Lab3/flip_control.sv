module flip_control (
    input  logic clk,
    input  logic rst,
    input  logic sw_flip,        // switch 
    input  logic [5:0] sel_idx,  // carta actual (0..15)
    output logic [15:0] reveal_mask
);
    // Sincronización de switch a clk
    logic sw_sync0, sw_sync1;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            sw_sync0 <= 1'b0;
            sw_sync1 <= 1'b0;
        end else begin
            sw_sync0 <= sw_flip;    
            sw_sync1 <= sw_sync0;
        end
    end

    // Genera la máscara, todas ocultas salvo la carta seleccionada
    always_comb begin
        reveal_mask = 16'h0000;
        if (sw_sync1) begin
            if (sel_idx < 6'd16)
                reveal_mask[sel_idx] = 1'b1;
        end
    end
endmodule
