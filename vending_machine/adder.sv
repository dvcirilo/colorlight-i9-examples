module adder (
    input  logic [7:0] a_i, b_i,
    output logic [7:0] sum_o
);

    assign sum_o = a_i + b_i;

endmodule
