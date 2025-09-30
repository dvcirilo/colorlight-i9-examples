module fibonacci (
    input  logic        clk,
    input  logic        rst,
    input  logic        start,
    input  logic [31:0] n,
    output logic [31:0] result,
    output logic        busy
);

    logic [31:0] counter;
    logic [31:0] a, b;
    logic        calculating;

    always_ff @(posedge clk) begin
        if (rst) begin
            result      <= 32'd0;
            busy        <= 1'b0;
            counter     <= 32'd0;
            a           <= 32'd0;
            b           <= 32'd1;
            calculating <= 1'b0;
        end else begin
            if (start && !busy) begin
                // iniciar cálculo
                calculating <= 1'b1;
                busy        <= 1'b1;
                counter     <= 32'd0;
                a           <= 32'd0;
                b           <= 32'd1;
                result      <= 32'd0;
            end else if (calculating) begin
                // lógica Fibonacci
                if (counter == 0)
                    result <= 32'd0;
                else if (counter == 1)
                    result <= 32'd1;
                else begin
                    result <= a + b;
                    a <= b;
                    b <= a + b;  // atualiza b corretamente
                end

                if (counter >= n) begin
                    calculating <= 1'b0;
                    busy        <= 1'b0;
                end else
                    counter <= counter + 1;
            end
        end
    end
endmodule
