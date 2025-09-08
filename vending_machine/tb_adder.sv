module tb_adder;
    logic [7:0] a, b;
    logic [7:0] out;

    adder dut (
        .a_i(a),
        .b_i(b),
        .sum_o(out)
    );

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_adder);
        a = 5;
        b = 8;
        #5
        b = 16;
        a = 255;
        #5
        $finish;
    end
endmodule
