module timer15_7seg(
    input  logic clk,
    input  logic reset,
    output logic [6:0] seg_tens,
    output logic [6:0] seg_ones
);
    localparam int unsigned CLK_HZ  = 50_000_000;
    localparam int unsigned DIV_MAX = CLK_HZ - 1;

    logic [$clog2(CLK_HZ)-1:0] div_cnt;
    logic tick_1hz;

    //Divisor 1 Hz
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            div_cnt  <= '0;
            tick_1hz <= 1'b0;
        end else begin
            if (div_cnt == DIV_MAX) begin
                div_cnt  <= '0;
                tick_1hz <= 1'b1;
            end else begin
                div_cnt  <= div_cnt + 1'b1;
                tick_1hz <= 1'b0;
            end
        end
    end

    //Contador
    logic [5:0] seconds;
    time_counter u_time (
        .clk(clk), .reset(reset), .tick(tick_1hz), .seconds(seconds)
    );

    //Dos digitos
    logic [3:0] tens, ones;
    assign tens = (seconds >= 6'd10) ? 4'd1 : 4'd0;
    assign ones = seconds - (tens ? 6'd10 : 6'd0);

    seven_segment_display u7_tens(.num(tens), .seg(seg_tens));
    seven_segment_display u7_ones(.num(ones), .seg(seg_ones));
endmodule
