module random(
    input  logic clk,
    input  logic rst,
    input  logic [7:0] seed,
    output logic [7:0] rnd
);
    logic fb;
    logic [15:0] free_counter;

    // contador libre
    always_ff @(posedge clk or posedge rst) begin
        if (rst) free_counter <= 16'h1;
        else     free_counter <= free_counter + 16'd1;
    end

   
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            rnd <= (8'hA5 ^ free_counter[7:0] ^ seed); 
        end else begin
            fb  = rnd[7] ^ rnd[5] ^ rnd[4] ^ rnd[3];
            rnd <= {rnd[6:0], fb};
        end
    end
endmodule
