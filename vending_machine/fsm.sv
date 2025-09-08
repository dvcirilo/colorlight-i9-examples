module fsm (
    input  logic clk_i,
    input  logic rst_ni,
    input  logic c,
    input  logic tot_lt_s,
    output logic tot_ld,
    output logic tot_clr,
    output logic d
);
    typedef enum logic [1:0] {
        INIT,
        WAIT,
        ADD,
        DISP
    } state_t;

    state_t state, next_state;

    // Registrador de estados
    always_ff @(posedge clk_i, negedge rst_ni)
        if (!rst_ni) state <= INIT;
        else state <= next_state;

    // Lógica de mudança de estados
    always_comb begin
        next_state = state;
        case (state)
            INIT:
                next_state = WAIT;
            WAIT:
                if (c)
                    next_state = ADD;
                else if (!tot_lt_s)
                    next_state = DISP;
            ADD:
                next_state = WAIT;
            DISP:
                next_state = INIT;
            default:
                next_state = INIT;
        endcase
    end

    // Lógica de saída (Moore)
    assign tot_ld = (state == ADD);
    assign tot_clr = (state == INIT);
    assign d = (state == DISP);
    
endmodule
