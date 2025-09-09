module tb_traffic_light;
    logic clk, rst_n;
    logic [2:0] st1;
    logic [2:0] st2;

    traffic_light #(
        .CLK_FREQ(1)
    ) dut (
        .clk_i(clk),
        .rst_ni(rst_n),
        .street1_o(st1),
        .street2_o(st2)
    );

    always begin
        #1 clk = ~clk;
    end

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0,tb_traffic_light);
        clk = 0;
        rst_n = 0;
        #10 rst_n = 1;
        #100000 $finish;
    end
endmodule
