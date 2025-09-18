module 7seg_display (
    input  logic [3:0] Y,
    output logic [6:0] seg  // (a, b, c, d, e, f, g)
);
    logic a, b, c, d, e, f, g;
    logic x3, x2, x1, x0;

    assign x3 = Y[3];
    assign x2 = Y[2];
    assign x1 = Y[1];
    assign x0 = Y[0];

    // Se pasa de un número de 4-bits a los segmentos del display que se encienden.
	 // Se reconocen los segmentos de display en este código del a-g en vez del 0-6. 

    // Segmento A: (A'⋅B'⋅C'⋅D) + (A'⋅B⋅C'⋅D') + (A⋅B'⋅C⋅D) + (A⋅B⋅C'⋅D)
	 
    assign a = (~x3 & ~x2 & ~x1 &  x0) |
               (~x3 &  x2 & ~x1 & ~x0) |
               ( x3 & ~x2 &  x1 &  x0) |
               ( x3 &  x2 & ~x1 &  x0);

    // Segmento B: (A′⋅B⋅C′⋅D) + (B⋅C⋅D′) + (A⋅C⋅D) + (A⋅B⋅D′)
	 
    assign b = (~x3 &  x2 & ~x1 &  x0) |
               ( x2 &  x1 & ~x0) |
               ( x3 &  x1 &  x0) |
               ( x3 &  x2 & ~x0);

    // Segmento C: (A′⋅B′⋅C⋅D′) + (A⋅B⋅D′) + (A⋅B⋅C)
	 
    assign c = (~x3 & ~x2 &  x1 & ~x0) |
               ( x3 &  x2 & ~x0) |
               ( x3 &  x2 &  x1);

    // Segmento D: (A′⋅B′⋅C′⋅D) + (A′⋅B⋅C′⋅D′) + (B⋅C⋅D) + (A⋅B′⋅C⋅D′)
	 
    assign d = (~x3 & ~x2 & ~x1 &  x0) |
               (~x3 &  x2 & ~x1 & ~x0) |
               ( x2 &  x1 &  x0) |
               ( x3 & ~x2 &  x1 & ~x0);

    // Segmento E: (A′⋅D) + (B′⋅C′⋅D) + (A′⋅B⋅C′)
	 
    assign e = (~x3 &  x0) |
               (~x2 & ~x1 &  x0) |
               (~x3 &  x2 & ~x1);

    // Segmento F: (A′⋅B′⋅D) + (A′⋅B′⋅C) + (A′⋅C⋅D) + (A⋅B⋅C′⋅D)
	 
    assign f = (~x3 & ~x2 &  x0) |
               (~x3 & ~x2 &  x1) |
               (~x3 &  x1 &  x0) |
               ( x3 &  x2 & ~x1 &  x0);

    // Segmento G: (A′⋅B′⋅C′) + (A′⋅B⋅C⋅D) + (A⋅B⋅C′⋅D′)
	 
    assign g = (~x3 & ~x2 & ~x1) |
               (~x3 &  x2 &  x1 &  x0) |
               ( x3 &  x2 & ~x1 & ~x0);

    assign seg = {a, b, c, d, e, f, g};

endmodule