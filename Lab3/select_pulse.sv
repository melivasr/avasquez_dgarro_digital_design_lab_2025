module select_pulse #(
    parameter int CLK_HZ      = 50_000_000,
    parameter int DEBOUNCE_MS = 12
)(
    input  logic clk,
    input  logic rst,
    input  logic sw_flip,     
    output logic sel_pulse    // 1 clk en flanco de subida "estable"
);
    // sincronizador
    logic s0, s1;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            s0 <= 1'b0;
            s1 <= 1'b0;
        end else begin
            s0 <= sw_flip;
            s1 <= s0;
        end
    end

    localparam int THRESH = (CLK_HZ/1000) * DEBOUNCE_MS;
    localparam int CW     = (THRESH > 0) ? $clog2(THRESH+1) : 1;

    // contadores para alto y bajo estables
    logic [CW-1:0] cnt_hi, cnt_lo;
    logic hi_stable, hi_stable_d, lo_stable;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_hi      <= '0;
            cnt_lo      <= '0;
            hi_stable   <= 1'b0;
            hi_stable_d <= 1'b0;
            lo_stable   <= 1'b1; // arrancamos "como si" estuviera estable en bajo
        end else begin
            // contar tiempo estable en alto
            if (s1) begin
                if (cnt_hi < THRESH[CW-1:0]) cnt_hi <= cnt_hi + {{(CW-1){1'b0}},1'b1};
            end else begin
                cnt_hi <= '0;
            end
            // contar tiempo estable en bajo
            if (!s1) begin
                if (cnt_lo < THRESH[CW-1:0]) cnt_lo <= cnt_lo + {{(CW-1){1'b0}},1'b1};
            end else begin
                cnt_lo <= '0;
            end

            hi_stable   <= (cnt_hi == THRESH[CW-1:0]);
            hi_stable_d <= hi_stable;
            lo_stable   <= (cnt_lo == THRESH[CW-1:0]);
        end
    end

    // Solo se genera un pulso tras haber visto un bajo estable antes
    logic armed;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            armed    <= 1'b0;
            sel_pulse<= 1'b0;
        end else begin
            sel_pulse <= 1'b0;
        
            if (lo_stable) armed <= 1'b1;
         
            if (armed && hi_stable && !hi_stable_d) begin
                sel_pulse <= 1'b1;
                armed     <= 1'b0; 
            end
        end
    end
endmodule
