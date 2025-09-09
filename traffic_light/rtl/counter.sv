module counter #(
    parameter int  WIDTH = 16
) (
    input  logic             clk_i,
    input  logic             rst_ni,
    input  logic             load_i,
    input  logic [WIDTH-1:0] data_i,
    output logic [WIDTH-1:0] data_o,
    output logic             zero_o
);

    always_ff @(posedge clk_i, negedge rst_ni) begin
        if (!rst_ni)
            data_o <= '1;
        else if (load_i)
            data_o <= data_i;
        else
            data_o <= data_o - 1;
    end

    assign zero_o = (data_o == '0);
endmodule
