module switches (
    input  logic [7:0] sw_i,
    input  logic btn0_i,
    input  logic btn1_i,
    output logic [7:0] led_o
);

    always_comb begin
        if (~btn0_i)
            led_o = '0;
        else if (~btn1_i)
            led_o = '1;
        else
            led_o = ~sw_i;
    end

endmodule
