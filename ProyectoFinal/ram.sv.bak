module ram (
    input  logic        clock,
    input  logic [2:0]  address_a,
    input  logic [2:0]  address_b,
    input  logic [31:0] data_a,
    input  logic [31:0] data_b,
    input  logic        wren_a,
    input  logic        wren_b,
    output logic [31:0] q_a,
    output logic [31:0] q_b
);
    // 8 palabras de 32 bits
    logic [31:0] mem [0:7];

    // Escritura síncrona
    always_ff @(posedge clock) begin
        if (wren_a) mem[address_a] <= data_a;
        if (wren_b) mem[address_b] <= data_b;
    end

    // Lectura combinacional
    always_comb begin
        q_a = mem[address_a];
        q_b = mem[address_b];
    end

endmodule
