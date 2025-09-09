module tb_edge_detector;
    logic clk, sig_input, sig_output;

    edge_detector dut (
        .clk_i(clk),
        .sig_i(sig_input),
        .sig_o(sig_output)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_edge_detector);

        clk = 0;
        sig_input = 0;
        #26 sig_input = 1;
        #20 sig_input = 0;
        #100 $finish;
    end
endmodule
