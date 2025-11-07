module deb (
    input  logic clk,
    input  logic rst_n,
    input  logic in,
    output logic out
);
    logic [1:0] ff_reg, ff_next;
    logic [7:0] cnt_reg, cnt_next;
    logic out_reg, out_next;
    
    logic in_changed, in_stable;
    
    assign out = out_reg;
    assign in_changed = ff_reg[0] ^ ff_reg[1];
    assign in_stable = (cnt_reg == 8'hFF);
    
    // Registro síncrono
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_reg <= 1'b0;
            ff_reg  <= 2'b00;
            cnt_reg <= 8'h00;
        end
        else begin
            out_reg <= out_next;
            ff_reg  <= ff_next;
            cnt_reg <= cnt_next;
        end
    end
    
    // Lógica combinacional
    always_comb begin
        ff_next[0] = in;
        ff_next[1] = ff_reg[0];
        cnt_next   = in_changed ? 8'h00 : (cnt_reg + 8'h01);
        out_next   = in_stable ? ff_reg[1] : out_reg;
    end
endmodule