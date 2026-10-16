module snail_fsm (
  input  logic       rst,
  input  logic       clk,
  input  logic [7:0] a,      // ASCII-код текущего символа
  output logic       y
);

  // ASCII-коды букв
  localparam logic [7:0] CH_A = 8'h41,   // 'A'
                         CH_N = 8'h4E,   // 'N'
                         CH_D = 8'h44,   // 'D'
                         CH_R = 8'h52,   // 'R'
                         CH_E = 8'h45,   // 'E'
                         CH_Y = 8'h59;   // 'Y'

  // Состояния — по-прежнему 3 бита (7 состояний)
  localparam logic [2:0] S0 = 3'd0,   // ничего
                         S1 = 3'd1,   // "A"
                         S2 = 3'd2,   // "AN"
                         S3 = 3'd3,   // "AND"
                         S4 = 3'd4,   // "ANDR"
                         S5 = 3'd5,   // "ANDRE"
                         S6 = 3'd6;   // "ANDREY" -> y = 1

  logic [2:0] state, next_state;

  always @(*) begin
    case (state)
      S0: next_state = (a == CH_A) ? S1 : S0;
      S1: next_state = (a == CH_N) ? S2 :
                       (a == CH_A) ? S1 : S0;
      S2: next_state = (a == CH_D) ? S3 :
                       (a == CH_A) ? S1 : S0;
      S3: next_state = (a == CH_R) ? S4 :
                       (a == CH_A) ? S1 : S0;
      S4: next_state = (a == CH_E) ? S5 :
                       (a == CH_A) ? S1 : S0;
      S5: next_state = (a == CH_Y) ? S6 :
                       (a == CH_A) ? S1 : S0;
      S6: next_state = (a == CH_A) ? S1 : S0;
      default: next_state = S0;
    endcase
  end

  always @(posedge clk) begin
    if (rst) state <= S0;
    else     state <= next_state;
  end

  assign y = (state == S6);

endmodule