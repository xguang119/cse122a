/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_simple_alu (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire [1:0] OPCODE = ui_in[7:6];
    wire [2:0] A = ui_in[5:3];
    wire [2:0] B = ui_in[2:0];

    logic [2:0] result;
    logic [0:0] carry;
    logic [3:0] answer;

    always @(*) begin
        result = 3'b000;
        carry = 1'b0;
        answer = 4'b0000;

        case (opcode)
            2'b00: begin //ADD
                answer = A + B;
                result = answer[2:0];
                carry = answer[3];
            end
            2'b01: begin //SUBTRACT
                answer = A - B;
                result = answer[2:0];
                carry = answer[3];
            end
            2'b00: begin //AND
                result = A & B;
            end
            2'b01: begin //OR
                result = A | B;
            end
        endcase
    end

    logic zero = (result = 3'b000);
    logic negative = result[2];

    //OUTPUT format:
    //[unused, negative, carry, zero, result, unused]
    assign uo_out = {1,b0, negative, carry, zero, result, 1'b0};
    assign uio_out = 0;
    assign uio_oe = 0;

  // List all unused inputs to prevent warnings
    wire _unused = &{ena, clk, rst_n, uio_in, 1'b0};

endmodule
