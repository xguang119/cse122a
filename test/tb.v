`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a FST file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Replace tt_um_example with your module name:
  tt_um_simple_alu dut (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

   integer op, a, b;
  logic [3:0] result;
  logic [2:0] expected_result;
  logic expected_carry;
  logic expected_zero;
  logic expected_negative;

  initial begin
    clk = 0;
    rst_n = 1;
    ena = 1;
    ui_in = 8'b0;
    uio_in = 8'b0;

    $display("Starting Simple ALU Testbench");

    // Test all opcodes and all A/B combinations
    for (op = 0; op < 4; op = op + 1) begin
      for (a = 0; a < 8; a = a + 1) begin
        for (b = 0; b < 8; b = b + 1) begin

          ui_in = {op[1:0], a[2:0], b[2:0]};
          #10;

          // Compute expected values
          result = 4'b0000;
          expected_carry = 1'b0;

          case (op)
            2'b00: begin //ADD
              result = a + b;
              expected_carry = result[3];
            end
            2'b01: begin //SUBTRACT
              result = a - b;
              expected_carry = result[3];
            end
            2'b10: begin //AND
              result = a & b;
            end
            2'b11: begin //OR
              result = a | b;
            end
          endcase

          expected_result = result[2:0];
          expected_zero = (expected_result == 3'b000);
          expected_negative = expected_result[2];

          if (uo_out[3:1] !== expected_result)
            $fatal(1, "FAIL RESULT: op=%b A=%0d B=%0d got=%b exp=%b",
                   op, a, b, uo_out[3:1], expected_result);

          if (uo_out[4] !== expected_zero)
            $fatal(1, "FAIL ZERO: op=%b A=%0d B=%0d got=%b exp=%b",
                   op, a, b, uo_out[4], expected_zero);

          if (uo_out[5] !== expected_carry)
            $fatal(1, "FAIL CARRY: op=%b A=%0d B=%0d got=%b exp=%b",
                   op, a, b, uo_out[5], expected_carry);

          if (uo_out[6] !== expected_negative)
            $fatal(1, "FAIL NEGATIVE: op=%b A=%0d B=%0d got=%b exp=%b",
                   op, a, b, uo_out[6], expected_negative);

        end
      end
    end

    $display("TESTS PASSED");

  end


   

endmodule
