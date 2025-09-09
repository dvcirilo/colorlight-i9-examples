`timescale 1ns/1ps
module tb_counter;
    logic clk, rst_n, load_s, end_timer;
    logic [3:0] count_value, count_out;

    counter #(
        .WIDTH(4)
    ) dut (
        .clk_i      (clk        ),
        .rst_ni     (rst_n      ),
        .load_i     (load_s     ),
        .data_i     (count_value),
        .data_o     (count_out  ),
        .zero_o     (end_timer  )
    );

    always begin
        #5 clk = ~clk;
    end

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0,tb_counter);
        clk = 0;
        rst_n = 0;
        load_s = 0;
        count_value = 0;
        #10 rst_n = 1;
        #63 rst_n = 0;
        #10 rst_n = 1;
        #80 count_value = 2;
        load_s = 1;
        #10 load_s = 0;
        #80 count_value = 9;
        load_s = 1;
        #10 load_s = 0;
        #200 $finish;
    end
endmodule
