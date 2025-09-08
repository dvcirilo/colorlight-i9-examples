module tb_debouncer;
    logic clk, button, out, rst_n;

    debouncer #(
        .CLK_FREQ(10000),
        .DEBOUNCE_MS(10)
    ) dut (
        .clk_i(clk),
        .rst_ni(rst_n),
        .button_i(button),
        .signal_o(out)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_debouncer);
        clk = 0;
        button = 0;
        rst_n = 0;
        #100 rst_n = 1;
        #2000
        repeat (99)
            #3 button = ~button;
        #1000 button = 1;
        #5000
        repeat (999)
            #3 button = ~button;
        #1000 button = 0;
        #100000 $finish;
    end
endmodule
