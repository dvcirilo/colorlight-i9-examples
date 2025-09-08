module register (
    input  logic       clk_i, clr_i, ld_i,
    input  logic [7:0] data_i,
    output logic [7:0] data_o
);

    logic [7:0] data;

    always_ff @(posedge clk_i)
        if (clr_i)
            data <= '0;
        else if (ld_i)
            data <= data_i;

    assign data_o = data;
endmodule
