module tb_datapath;
    
    logic [7:0] s, a;
    logic tot_ld, tot_clr, clk, tot_lt_s;
    
    datapath dut (
        .s(s),
        .a(a),
        .tot_ld(tot_ld),
        .tot_clr(tot_clr),
        .clk_i(clk),
        .tot_lt_s(tot_lt_s)
    );

    always
        #5 clk = ~clk;

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_datapath);
        clk = 0;
        s = 200;
        a = 0;
        tot_ld = 0;
        tot_clr = 1;
        #10
        tot_clr = 0;
        #10
        a = 50;
        tot_ld = 1;
        #10
        tot_ld = 0;
        #10
        a = 50;
        tot_ld = 1;
        #10
        tot_ld = 0;
        #10
        a = 100;
        tot_ld = 1;
        #10
        tot_ld = 0;
        #100 $finish;
    end
endmodule
