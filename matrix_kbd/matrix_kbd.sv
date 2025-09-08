module matrix_kbd (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic [3:0] column_i,
    output logic [3:0] row_o,
    output logic [7:0] led_o
);
    logic clk;

    clk_div #(
        .CLK_FREQ(25_000_000),
        .OUT_FREQ(40)
    ) ckdiv0 (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .clk_o(clk)
    );

    logic [3:0] row;
    logic [7:0] out;

    always_ff @(posedge clk, negedge rst_ni)
        if (!rst_ni) begin
            row <= 4'b0001;
            led_o <= '0;
        end else if (row == 4'b0000) begin
            row <= 4'b0001;
        end else begin
            row <= row << 1;
            if (out[3:0] != '0 || (row & led_o[7:4]) != '0)
                led_o <= out;
        end

    assign out = {row, ~column_i};
    assign row_o = ~row;

endmodule
