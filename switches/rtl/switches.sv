module switches (
    input  logic [7:0] SW2_i,
    input  logic SW1_i,
    input  logic SW3_i,
    output logic [7:0] led_o
);

    always_comb begin
        if (~SW1_i)
            led_o = '0;
        else if (~SW3_i)
            led_o = '1;
        else
            led_o = ~SW2_i;
    end

endmodule
