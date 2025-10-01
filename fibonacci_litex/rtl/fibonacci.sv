module fibonacci (
    input  logic        clk_i,
    input  logic        rst_ni,
    input  logic        start_i,
    input  logic [31:0] n_i,
    output logic [31:0] result_o,
    output logic        busy_o
);

    logic [31:0] counter, counter_next;
    logic [31:0] a, a_next;
    logic [31:0] result_next;

    typedef enum logic {
        IDLE,
        CALC
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            state     <= IDLE;
            counter   <= 32'd0;
            a         <= 32'd0;
            result_o  <= 32'd0;
        end else begin
            state     <= next_state;
            counter   <= counter_next;
            a         <= a_next;
            result_o  <= result_next;
        end
    end

    always_comb begin
        next_state   = state;
        counter_next = counter;
        a_next       = a;
        result_next  = result_o;

        case (state)
            IDLE: begin
                if (start_i) begin
                    counter_next = 32'd2;
                    a_next       = 32'd0;
                    result_next  = 32'd1;
                    next_state   = CALC;
                    if (n_i < 32'd2) begin
                        result_next = n_i;
                    end
                end
            end
            CALC: begin
                result_next  = a + result_o;
                a_next       = result_o;
                counter_next = counter + 1;

                if (counter >= n_i) begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    assign busy_o = (state == CALC);

endmodule
