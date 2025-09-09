module edge_detector (
    input logic clk_i, sig_i,
    output logic sig_o
);

    logic sig_reg;

    always_ff @(posedge clk_i)
        sig_reg <= sig_i;

    assign sig_o = sig_i & ~sig_reg;
endmodule
