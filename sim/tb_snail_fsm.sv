`timescale 1ns / 1ns

module tb_snail_fsm;
  parameter TRANSITIONS = 49;

  logic        rst = 0;
  logic        clk = 0;                    
  logic [8:0]  test_vectors [TRANSITIONS]; 
  logic [7:0]  a;                          
  logic        y, y_ref;

  initial begin
    $dumpfile("work/wave.ocd");
    $dumpvars(0, tb_snail_fsm);
  end

  always #5 clk = ~clk;                    

  snail_fsm dut (
    .rst(rst),
    .clk(clk),
    .a  (a),
    .y  (y)
  );

  initial begin
    $readmemb("sequence_full_path.tv", test_vectors);

    @(posedge clk); rst = 1'b1;
    @(posedge clk); rst = 1'b0;

    for (int i = 0; i < TRANSITIONS; i++) begin
      {a, y_ref} = test_vectors[i];
      @(posedge clk);
      #1;
      assert (y == y_ref)
        else $error($sformatf(
          "Wrong output on test vector %0d: a = %h, y_ref = %b, y = %b",
          i, a, y_ref, y));
    end

    $display("All %0d tests passed.", TRANSITIONS);
    $finish;
  end

endmodule