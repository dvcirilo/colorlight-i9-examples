module pinout_identifier (
    input  logic clk_i,
    output logic pin1_o,
    output logic pin2_o
);

logic [24:0] counter;

always_ff @(posedge clk_i) begin
    counter <= counter + 1;
end

assign pin1_o = counter[24];
assign pin2_o = counter[23];

endmodule
