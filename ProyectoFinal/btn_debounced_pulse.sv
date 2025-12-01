module btn_debounced_pulse (
    input  logic clk,
    input  logic rst,
    input  logic btn_n,    // activo-bajo desde el pin
    output logic pulse     // pulso 1 ciclo por presión
);
    // Sincronización a clk
    logic b_sync0, b_sync1;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            b_sync0 <= 1'b1;
            b_sync1 <= 1'b1;
        end else begin
            b_sync0 <= btn_n;
            b_sync1 <= b_sync0;
        end
    end

  
    logic [15:0] divcnt;     
    logic        sample_tick;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            divcnt      <= 16'd0;
            sample_tick <= 1'b0;
        end else begin
            if (divcnt == 16'd49999) begin
                divcnt      <= 16'd0;
                sample_tick <= 1'b1;
            end else begin
                divcnt      <= divcnt + 16'd1;
                sample_tick <= 1'b0;
            end
        end
    end

    logic       debounced;
    logic       last_sampled;
    logic [3:0] stabcnt;  // cuenta 0..10

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            last_sampled <= 1'b1;
            stabcnt      <= 4'd0;
            debounced    <= 1'b1;
        end else if (sample_tick) begin
            if (b_sync1 == last_sampled) begin
                if (stabcnt < 4'd10) stabcnt <= stabcnt + 4'd1;
                if (stabcnt == 4'd9) debounced <= b_sync1; // estable tras 10 ms
            end else begin
                last_sampled <= b_sync1;
                stabcnt      <= 4'd0;
            end
        end
    end

    // Pulso  activo-bajo
    logic debounced_d;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) debounced_d <= 1'b1;
        else     debounced_d <= debounced;
    end

    assign pulse = (debounced_d == 1'b1) && (debounced == 1'b0);
endmodule