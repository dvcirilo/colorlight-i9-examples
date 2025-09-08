module tb_register;
    logic clk, clr, ld;
    logic [7:0] data_in, data_out;

    register dut (
        .clk_i(clk),
        .clr_i(clr),
        .ld_i(ld),
        .data_i(data_in),
        .data_o(data_out)
    );

    always
        #5 clk = ~clk;

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_register);
        clk = 0;
        clr = 0;
        ld = 0;
        data_in = 8'b0;
        #10
        data_in = 16;
        ld = 1;
        #10
        ld = 0;
        #10
        data_in = 28;
        #30
        clr = 1;
        #10
        clr = 0;
        #30 $finish;
    end
endmodule
