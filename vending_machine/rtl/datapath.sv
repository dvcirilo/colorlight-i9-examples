module datapath (
    input  logic [7:0] s, a,
    input  logic tot_ld, tot_clr, clk_i,
    output logic tot_lt_s
);
    logic [7:0] data, sum_out;

    comparator comp (
        .a_i    (data    ),
        .b_i    (s       ),
        .lt_o   (tot_lt_s)
    );

    adder add_1 (
        .a_i    (data    ),
        .b_i    (a       ),
        .sum_o  (sum_out )
    );

    register tot (
        .clk_i  (clk_i   ),
        .clr_i  (tot_clr ),
        .ld_i   (tot_ld  ),
        .data_i (sum_out ),
        .data_o (data    )
    );

endmodule
