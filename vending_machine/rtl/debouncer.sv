module debouncer #(
    parameter int CLK_FREQ = 25_000_000,
    parameter int DEBOUNCE_MS = 10
) (
    input logic clk_i, rst_ni, button_i,
    output logic signal_o
);
    localparam DELAY_CYCLES = (CLK_FREQ*DEBOUNCE_MS)/1000;
    localparam WIDTH = $clog2(DELAY_CYCLES);

    logic [WIDTH-1:0] delay_reg;
    logic button_state;

    always_ff @(posedge clk_i) begin
        if (!rst_ni) begin
            delay_reg <= '1 - DELAY_CYCLES;
            signal_o <= '0;
            button_state <= button_i;
        end else begin
            if (button_i != button_state) begin
                delay_reg <= '1 - DELAY_CYCLES;
                button_state <= button_i;
            end else
                delay_reg <= delay_reg + 1;

            if (delay_reg == '1)
                signal_o <= button_state;
        end
    end
    
endmodule
