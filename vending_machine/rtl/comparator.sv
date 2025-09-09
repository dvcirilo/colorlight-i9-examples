module comparator (
    input logic [7:0] a_i, b_i,
    output logic lt_o
);

    assign lt_o = (a_i < b_i);

endmodule
