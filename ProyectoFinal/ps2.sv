module ps2 (
    input  logic       PS2_KBCLK,
    input  logic       PS2_KBDAT,
    input  logic       rst_n,
    input  logic       computerClk,
    output logic [15:0] hexo
);
    // Estados
    localparam [1:0] WAITING_FOR_START = 2'd0;
    localparam [1:0] SENDING_DATA      = 2'd1;
    localparam [1:0] END_PROCESSING    = 2'd2;
    
    logic PS2_KBCLK_DEB;
    logic [1:0] state_reg;
    logic parity_reg;
    logic [3:0] n_reg;
    logic [8:0] data_reg;
    logic [15:0] bin_code_reg;
    logic [15:0] display_bin_code_reg;
    logic counter_reg;
    
    // Debouncer para el reloj PS/2
    deb deb0 (
        .clk(computerClk),
        .rst_n(rst_n),
        .in(PS2_KBCLK),
        .out(PS2_KBCLK_DEB)
    );
    
    assign hexo = display_bin_code_reg;
    
    // Máquina de estados del reloj PS/2
    always_ff @(negedge PS2_KBCLK_DEB or negedge rst_n) begin
        if (!rst_n) begin
            state_reg            <= WAITING_FOR_START;
            n_reg                <= 4'd0;
            data_reg             <= 9'd0;
            parity_reg           <= 1'd0;
            bin_code_reg         <= 16'd0;
            counter_reg          <= 1'd0;
            display_bin_code_reg <= 16'd0;
        end
        else begin
            case (state_reg)
                WAITING_FOR_START: begin
                    if (PS2_KBDAT == 1'b0) begin  // Bit de START
                        n_reg      <= 4'd9;
                        data_reg   <= 9'd0;
                        state_reg  <= SENDING_DATA;
                        if (data_reg[7:0] != 8'hE0 && data_reg[7:0] != 8'hF0) begin
                            bin_code_reg <= 16'd0;
                        end
                    end
                end
                
                SENDING_DATA: begin
                    if (n_reg == 4'd9) begin
                        parity_reg <= PS2_KBDAT;
                    end
                    else begin
                        parity_reg <= parity_reg ^ PS2_KBDAT;
                    end
                    
                    data_reg <= {PS2_KBDAT, data_reg[8:1]};
                    
                    if (n_reg == 4'd1) begin
                        state_reg <= END_PROCESSING;
                    end
                    else begin
                        n_reg <= n_reg - 4'd1;
                    end
                end
                END_PROCESSING: begin
                    if (PS2_KBDAT == 1'b1) begin  
                        if (parity_reg) begin
                            bin_code_reg <= {bin_code_reg[7:0], data_reg[7:0]};
                            
                            if (counter_reg == 1'b0 || 
                                data_reg[7:0] == 8'hE0 || 
                                data_reg[7:0] == 8'hF0) begin
                                counter_reg <= 1'b1;
                            end
                            else begin
                                display_bin_code_reg <= {bin_code_reg[7:0], data_reg[7:0]};
                                counter_reg <= 1'b0;
                            end
                        end
                        else begin
                            display_bin_code_reg <= 16'hEEEE;
                        end
                        state_reg <= WAITING_FOR_START;
                    end
                end
                
                default: state_reg <= WAITING_FOR_START;
            endcase
        end
    end
endmodule