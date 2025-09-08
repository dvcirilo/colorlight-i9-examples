module tb_fsm;
    logic clk, rst_n, c, tot_lt_s, tot_ld, tot_clr, d;

    fsm dut (
        .clk_i(clk),
        .rst_ni(rst_n),
        .c(c),
        .tot_lt_s(tot_lt_s),
        .tot_ld(tot_ld),
        .tot_clr(tot_clr),
        .d(d)
    );

    always
        #5 clk = ~clk;

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_fsm);

        clk = 0;
        rst_n = 0;
        c = 0;
        tot_lt_s = 1;

        #10
        rst_n = 1;
        #20
        c = 1;
        #10
        c = 0;
        #20
        tot_lt_s = 0;
        #10
        tot_lt_s = 1;
        #30 $finish;
    end

endmodule
