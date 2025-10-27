module blink (
    input  logic clk_i,
    input  logic btn_i,
    output logic [16:0] led_o
);
    localparam MAX = 1_562_500;
    localparam WIDTH = $clog2(MAX);

    logic rst_s;
    logic clk_s;

    assign clk_s = clk_i;

    rst_gen rst_inst (
        .clk_i      (clk_s),
        .rst_i      (1'b0),
        .rst_o      (rst_s)
    );

    logic  [WIDTH-1:0] cpt_s;
    logic  [WIDTH-1:0] cpt_next_s = cpt_s + 1'b1;

    logic  end_s = cpt_s == MAX-1;

    always_ff @(posedge clk_s) begin
        cpt_s <= (rst_s || end_s) ? {WIDTH{1'b0}} : cpt_next_s;

        if (rst_s || ~btn_i)
            led_o <= 17'b1;
        else if (end_s) begin
            led_o <= (led_o == 0) ? 17'b1 : (led_o << 1) ^ 17'b10000000000000000;
        end
    end
endmodule
