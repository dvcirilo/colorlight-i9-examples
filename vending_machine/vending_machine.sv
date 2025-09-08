module vending_machine (
    input  logic clk_i, rst_ni, c,
    input  logic [7:0] a,// s,
    output logic d, clk_o, pulse_o
);
    localparam CLK_FREQ = 25_000_000;    
    localparam FSM_CLK = 10;    

    logic tot_ld, tot_clr, tot_lt_s, clk, db_c, pulse_c;

    clk_div #(
        .CLK_FREQ(CLK_FREQ),
        .OUT_FREQ(FSM_CLK)
    ) clkdiv (
        .clk_i    (clk_i   ),
        .rst_ni   (rst_ni  ),
        .clk_o    (clk     )
    );

    debouncer #(
        .CLK_FREQ(FSM_CLK),
        .DEBOUNCE_MS(1)
    ) db0 (
        .clk_i    (clk     ),
        .rst_ni   (rst_ni  ),
        .button_i (~c      ), // negado pois os botões são pull up
        .signal_o (db_c    )
    );

    edge_detector ed0 (
        .clk_i    (clk     ),
        .sig_i    (db_c    ),
        .sig_o    (pulse_c )
    );

    datapath dp (
        .s        (8'd200  ),
        .a        (~a      ), // negado pois os botões são pull up
        .tot_ld   (tot_ld  ),
        .tot_clr  (tot_clr ),
        .clk_i    (clk     ),
        .tot_lt_s (tot_lt_s)
    );

    fsm fsm0 (
        .clk_i    (clk     ),
        .rst_ni   (rst_ni  ),
        .c        (pulse_c ),
        .tot_lt_s (tot_lt_s),
        .tot_ld   (tot_ld  ),
        .tot_clr  (tot_clr ),
        .d        (d       )
    );

    assign clk_o = clk;
    assign pulse_o = pulse_c;
endmodule
