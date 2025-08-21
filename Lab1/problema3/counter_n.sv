module counter_n #(
    parameter int N = 6
) (
    input  logic             clk,     // reloj
    input  logic             arst,    // reset asíncrono, activo en 1
    input  logic             en,      // pulso de habilitación (incrementa 1)
    input  logic             load,    // carga síncrona del valor d
    input  logic [N-1:0]     d,       // dato a cargar
    output logic [N-1:0]     q        // salida
);
    always_ff @(posedge clk or posedge arst) begin
        if (arst)      q <= '0;
        else if (load) q <= d;
        else if (en)   q <= q + 1'b1;
    end
endmodule