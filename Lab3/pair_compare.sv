module pair_compare(
    input  logic       compare_enable,   
    input  logic [1:0] sel_count,        
    input  logic [3:0] first_val,
    input  logic [3:0] second_val,
    output logic       match
);
    always_comb begin
        match = compare_enable && (sel_count == 2'd2) &&
                (first_val[2:0] == second_val[2:0]); 
    end
endmodule
