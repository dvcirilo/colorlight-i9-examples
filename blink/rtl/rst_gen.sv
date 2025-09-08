module rst_gen (
	input  logic clk_i,
	input  logic rst_i,
	output logic rst_o
);

    /* try to generate a reset */
    logic [2:0]	rst_cpt;
    always_ff @(posedge clk_i) begin
        if (rst_i)
            rst_cpt = 3'b0;
        else begin
            if (rst_cpt == 3'b100)
                rst_cpt = rst_cpt;
            else
                rst_cpt = rst_cpt + 3'b1;
        end
    end

    assign rst_o = !rst_cpt[2];

endmodule
