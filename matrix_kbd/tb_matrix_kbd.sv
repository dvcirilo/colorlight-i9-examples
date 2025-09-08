module tb_matrix_kbd;
    logic clk, rst_n;
    logic [3:0] column, row;
    logic [7:0] led;

    matrix_kbd dut (
        .clk_i(clk),
        .rst_ni(rst_n),
        .column_i(column),
        .row_i(row),
        .led_o(led)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("out.vcd");
        $dumpvars(0, tb_matrix_kbd);
        clk = 0;
        #10
        rst_n = 0;
        #10
        rst_n = 1;
        #10 rst_n = 1;
        #10 rst_n = 0;
        #10 rst_n = 1;
        #200 column = 4'b0010;
        #1000 column = 4'b0000;
        #2000 column = 4'b1000;
        #300 $finish;
    end
endmodule
