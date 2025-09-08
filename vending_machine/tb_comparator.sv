module tb_comparator;
    logic [7:0] a, b;
    logic lt;

    comparator dut (
        .a_i(a),
        .b_i(b),
        .lt_o(lt)
    );

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_comparator);
        a = 5;
        b = 8;
        #5
        b = 5;
        a = 8;
        #5
        $finish;
    end
endmodule
