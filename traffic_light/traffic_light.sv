module traffic_light #(
    parameter int      CLK_FREQ    = 25_000_000, // clk da FPGA
    parameter int      GREEN_TIME  = 20,
    parameter int      YELLOW_TIME = 5
) (
    input  logic       clk_i,
    input  logic       rst_ni,
    output logic [2:0] street1_o,
    output logic [2:0] street2_o
);

    localparam GREEN_TIME_DIV = CLK_FREQ*GREEN_TIME;
    localparam YELLOW_TIME_DIV = CLK_FREQ*YELLOW_TIME;
    localparam WIDTH = $clog2(GREEN_TIME_DIV);

    logic [WIDTH-1:0] count_value;
    logic end_timer, load_s;

    counter #(
        .WIDTH(WIDTH)
    ) cnt1 (
        .clk_i      (clk_i      ),
        .rst_ni     (rst_ni     ),
        .load_i     (load_s     ),
        .data_i     (count_value),
        .data_o     (           ),
        .zero_o     (end_timer  )
    );

// Definição dos estados
    typedef enum logic [2:0] {
        INIT,
        GREEN,
        YELLOW_A, // Amarelo da primeira rua
        RED,
        YELLOW_B  // Amarelo da segunda rua
    } state_t;

    state_t state, next_state;

// Registrador de estados com reset assíncrono
    always_ff @(posedge clk_i, negedge rst_ni)
        if (!rst_ni) state <= INIT;
        else state <= next_state; // Se vier o clk e não tiver reset, atualiza o registrador de estado.

// Lógica de mudança de estados
    always_comb begin
        next_state = state; // Caso padrão, o próximo estado é o estado atual, ou seja, se mantém no mesmo estado.
        count_value = '0; // Caso padrão
        load_s = '0;
        case (state)
            INIT: begin
                count_value = GREEN_TIME_DIV; // Define o valor de contagem do timer para o próximo estado
                load_s = '1; // Inicializa o timer
                next_state = GREEN;
            end
            GREEN:
                if (end_timer) begin // Se o timer atual tiver finalizado:
                    count_value = YELLOW_TIME_DIV; // Carrega a contagem do próximo estado
                    load_s = '1; // Inicializa o timer
                    next_state = YELLOW_A; // Atribui o próximo estado
                end else
                    load_s = '0; // Desabilita o load do contador, e se mantém no mesmo estado (primeira linha desse bloco)
            YELLOW_A:
                if (end_timer) begin
                    count_value = GREEN_TIME_DIV;
                    load_s = '1;
                    next_state = RED;
                end else
                    load_s = '0;
            RED:
                if (end_timer) begin
                    count_value = YELLOW_TIME_DIV;
                    load_s = '1;
                    next_state = YELLOW_B;
                end else
                    load_s = '0;
            YELLOW_B:
                if (end_timer) begin
                    count_value = GREEN_TIME_DIV;
                    load_s = '1;
                    next_state = GREEN;
                end else
                    load_s = '0;
            default:
                // Reinicializa caso state por algum motivo receba um valor indefinido (3'b101, 3'b110 e 3'b111)
                // Importante pois estamos usando 3 bits (8 estados possíveis), mas só usamos 5.
                next_state = INIT;
        endcase
    end

// Lógica das saídas (Moore). Poderia ter sido escrito dentro do bloco
// anterior, mas aqui fica mais legível e ocupa menos linhas.
    assign street1_o = {(state == RED || state == YELLOW_B), (state == YELLOW_A), (state == GREEN)};
    assign street2_o = {(state == GREEN || state == YELLOW_A), (state == YELLOW_B), (state == RED)};

endmodule
