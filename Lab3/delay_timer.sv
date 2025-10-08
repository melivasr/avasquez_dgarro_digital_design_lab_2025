module delay_timer #(
    parameter int unsigned CLK_HZ = 50_000_000,
    parameter int unsigned MS     = 7000      // 7000 ms
)(
    input  logic clk,
    input  logic rst,
    input  logic start,        // nivel de la FSM 
    output logic done_pulse    // 1 ciclo
);
    // ciclos a esperar
    localparam int unsigned TARGET = (CLK_HZ/1000)*MS;
    localparam int CW = (TARGET>1) ? $clog2(TARGET) : 1;

    logic running;
    logic [CW-1:0] cnt;

    // flanco de subida de start
    logic start_d;
    always_ff @(posedge clk or posedge rst) begin
        if (rst) start_d <= 1'b0;
        else     start_d <= start;
    end
    wire start_rise = start & ~start_d;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            running    <= 1'b0;
            cnt        <= '0;
            done_pulse <= 1'b0;
        end else begin
            done_pulse <= 1'b0;

            // armar solo en flanco de subida
            if (!running && start_rise) begin
                running <= 1'b1;
                cnt     <= '0;
            end else if (running) begin
                // cuenta 0 TARGET-1
                if (cnt == (TARGET-1)) begin
                    running    <= 1'b0;
                    done_pulse <= 1'b1;  
                end else begin
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end
endmodule
