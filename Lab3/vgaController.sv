module vgaController (
    input  logic vgaclk,
    output logic hsync, vsync, sync_b, blank_b,
    output logic [9:0] x, y
);
    localparam int HACTIVE = 640;
    localparam int HFP     = 16;
    localparam int HSYN    = 96;
    localparam int HBP     = 48;
    localparam int HMAX    = HACTIVE + HFP + HSYN + HBP;

    localparam int VACTIVE = 480;
    localparam int VFP     = 10;
    localparam int VSYN    = 2;
    localparam int VBP     = 33;
    localparam int VMAX    = VACTIVE + VFP + VSYN + VBP;

    always_ff @(posedge vgaclk) begin
        if (x == HMAX-1) begin
            x <= 0;
            if (y == VMAX-1) y <= 0;
            else             y <= y + 1;
        end else begin
            x <= x + 1;
        end
    end

    assign hsync  = ~((x >= HACTIVE + HFP) && (x < HACTIVE + HFP + HSYN));
    assign vsync  = ~((y >= VACTIVE + VFP) && (y < VACTIVE + VFP + VSYN));
    assign sync_b = hsync & vsync;
    assign blank_b = (x < HACTIVE) && (y < VACTIVE);
endmodule