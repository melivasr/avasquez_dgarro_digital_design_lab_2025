module switch_debounced #(
    parameter int CLK_HZ       = 50_000_000,
    parameter int DEBOUNCE_MS  = 20,   // antirrebote
    parameter int HOLD_MS      = 80,   // presionado 
    parameter bit ACTIVE_HIGH  = 1'b1
)(
    input  logic clk,
    input  logic rst,
    input  logic sw_in,
    output logic level,           // nivel estable (debounced) 
    output logic posedge_pulse    // 1 clk al cumplir HOLD_MS en activo
);
    //entrada asíncrona a clk
    logic s0, s1;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin s0 <= 1'b0; s1 <= 1'b0; end
        else begin s0 <= sw_in;    s1 <= s0;  end
    end

    // Normaliza a "activo=1"
    wire active_sample = (ACTIVE_HIGH) ? s1 : ~s1;

    // Debounce: requiere DEBOUNCE_MS 
    localparam int TH_DB  = (CLK_HZ/1000)*DEBOUNCE_MS;
    localparam int CW_DB  = (TH_DB>0) ? $clog2(TH_DB) : 1;

    logic [CW_DB-1:0] cnt_db;
    logic stable_active;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_db        <= '0;
            stable_active <= 1'b0;     // arranca inactivo para evitar falsos
        end else begin
            if (active_sample == stable_active) begin
                cnt_db <= '0;          // sin intento de cambio
            end else begin
                if (cnt_db >= TH_DB-1) begin
                    stable_active <= active_sample; // aceptar cambio
                    cnt_db        <= '0;
                end else begin
                    // contador saturado
                    cnt_db <= (cnt_db == TH_DB-1) ? cnt_db : (cnt_db + 1'b1);
                end
            end
        end
    end

    assign level = stable_active;

    // Hold: dispara 1 pulso solo si se mantuvo en activo por HOLD_MS
    localparam int TH_HOLD = (CLK_HZ/1000)*HOLD_MS;
    localparam int CW_HOLD = (TH_HOLD>0) ? $clog2(TH_HOLD) : 1;

    logic [CW_HOLD-1:0] hold_cnt;
    logic armed, fired;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            hold_cnt      <= '0;
            armed         <= 1'b0;
            fired         <= 1'b0;
            posedge_pulse <= 1'b0;
        end else begin
            posedge_pulse <= 1'b0;

            // Inactivo estable armar, limpiar y el contador de hold
            if (!stable_active) begin
                armed    <= 1'b1;
                fired    <= 1'b0;
                hold_cnt <= '0;
            end else begin
                // Activo establ contar tiempo de sostén si arm y no ha disparado
                if (armed && !fired) begin
                    if (hold_cnt >= TH_HOLD-1) begin
                        posedge_pulse <= 1'b1; // dispara una sola vez
                        fired         <= 1'b1; 
                    end else begin
                        
                        hold_cnt <= (hold_cnt == TH_HOLD-1) ? hold_cnt : (hold_cnt + 1'b1);
                    end
                end
            end
        end
    end
endmodule