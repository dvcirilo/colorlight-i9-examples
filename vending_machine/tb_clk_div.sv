module tb_clk_div;
    logic clk, rst_n, clk_out;

    clk_div #(
        .CLK_FREQ(100),
        .OUT_FREQ(10)
    ) dut (
        .clk_i(clk),
        .rst_ni(rst_n),
        .clk_o(clk_out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_clk_div);
        clk = 0;
        rst_n = 0;
        #10 rst_n = 1;
        #10000 $finish;
    end
endmodule
