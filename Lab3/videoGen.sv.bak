module temporizador (
    input logic clk,        // Reloj del sistema
    input logic reset,      // Señal de reinicio
    input logic start,      // Inicia el temporizador
    output logic timeout    // Se activa cuando el temporizador alcanza el valor deseado
);

    parameter WIDTH = 32;           // Ancho del contador, ajustable según necesidades
    parameter DELAY_CYCLES = 100;   // Número de ciclos de reloj para el temporizador
    logic [WIDTH-1:0] counter;      // Contador

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reiniciar el contador y la señal de timeout
            counter <= 0;
            timeout <= 1'b0;
        end else if (start) begin
            if (counter >= DELAY_CYCLES) begin
                // El temporizador alcanzó el valor deseado
                timeout <= 1'b1;
                counter <= 0; // Reinicia el contador si se desea auto-reinicio
            end else begin
                // Incrementar el contador y asegurar que timeout esté desactivado
                counter <= counter + 1;
                timeout <= 1'b0;
            end
        end else begin
            // Reiniciar el contador si el temporizador no está activo
            counter <= 0;
            timeout <= 1'b0;
        end
    end

endmodule