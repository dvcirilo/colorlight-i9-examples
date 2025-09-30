`timescale 1ns/1ps

module tb_fibonacci;

    logic clk;
    logic rst;
    logic start;
    logic [31:0] n;
    logic [31:0] result;
    logic busy;

    // instância do módulo
    fibonacci uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .n(n),
        .result(result),
        .busy(busy)
    );

    // clock
    initial clk = 0;
    always #5 clk = ~clk; // 100MHz simulado (10ns período)

    initial begin
        // inicialização
        rst = 1;
        start = 0;
        n = 10; // por exemplo, 10º termo
        #20;
        rst = 0;

        // iniciar cálculo
        #10;
        start = 1;
        #10;
        start = 0;

        // esperar cálculo terminar
        wait (busy == 0);
        $display("Fibonacci(%0d) = %0d", n, result);

        // teste outro valor
        #10;
        n = 15;
        start = 1;
        #10;
        start = 0;
        wait (busy == 0);
        $display("Fibonacci(%0d) = %0d", n, result);

        $finish;
    end
endmodule
