module tb_vending_machine;
    logic clk, rst_n, c, d;
    logic [7:0] a, s;

    vending_machine dut (
        .clk_i(clk),
        .rst_ni(rst_n),
        .c(~c), // negado pra compensar os botões pull-up
        .a(~a), // negado pra compensar os botões pull-up
        // .s(s),
        .d(d)
    );

    always
        #5 clk = ~clk;

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_vending_machine);
        $monitor("%b\n", d);
        clk = 0;
        rst_n = 0;
        c = 0;
        a = 0;
        // s = 200;
        #40000
        rst_n = 1;
        #100000
        a = 50;
        c = 1;
        #2000
        c = 0;
        #60000
        c = 1;
        #20000
        c = 0;
        #60000
        a = 110;
        c = 1;
        #2000
        c = 0;
        #200000 $finish;
    end
endmodule
