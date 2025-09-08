module clk_div #(
    parameter int CLK_FREQ = 25_000_000,
    parameter int OUT_FREQ = 1000
) (
    input logic clk_i, rst_ni,
    output logic clk_o
);
    localparam MAX_COUNT = (CLK_FREQ/OUT_FREQ)/2;
    localparam WIDTH = $clog2(MAX_COUNT);

    logic [WIDTH-1:0] count_reg;

    always_ff @(posedge clk_i)
        if (!rst_ni) begin
            clk_o <= 0;
            count_reg <= '0;
        end else begin
            count_reg <= count_reg + 1;
            if (count_reg == MAX_COUNT-1) begin
                clk_o <= ~clk_o;
                count_reg <= '0;
            end
        end
endmodule
