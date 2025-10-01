module tb_fibonacci;

    logic clk;
    logic rst_n;
    logic start;
    logic [31:0] n;
    logic [31:0] result;
    logic busy;

    fibonacci dut (
        .clk_i    (clk   ),
        .rst_ni   (rst_n ),
        .start_i  (start ),
        .n_i      (n     ),
        .result_o (result),
        .busy_o   (busy  )
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("build/fibonacci.vcd");
        $dumpvars(0,dut);
        clk = 0;
        rst_n = 0;
        start = 0;
        #20;
        rst_n = 1;

        for (n = 0; n < 20; n++) begin
            #10;
            start = 1;
            #10;
            start = 0;
            wait (busy == 0);
            $display("Fibonacci(%0d) = %0d", n, result);
        end
        $finish;
    end
endmodule
