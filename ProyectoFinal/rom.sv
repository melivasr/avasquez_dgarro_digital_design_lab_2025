module rom (
    input  logic [5:0] address,
    input  logic       clock,
    output logic [31:0] q
);

    // Memoria interna inicializada con .mif
    logic [31:0] mem [0:63];

    initial begin
        $readmemb("instruction_memory.mif", mem);
    end

    // Registro de salida para sincronizar con el reloj
    logic [31:0] q_reg;

    always_ff @(posedge clock) begin
        q_reg <= mem[address];
    end

    assign q = q_reg;

endmodule