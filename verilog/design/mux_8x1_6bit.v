`timescale 1ns / 1ps
// From Lab 5: 8-to-1 multiplexer, 6-bit words.
module mux_8x1_6bit(
    input  [5:0] i0, i1, i2, i3, i4, i5, i6, i7,
    input  [2:0] s,
    output reg [5:0] d_out
    );
    always @(*)
        case (s)
            3'd0: d_out = i0;
            3'd1: d_out = i1;
            3'd2: d_out = i2;
            3'd3: d_out = i3;
            3'd4: d_out = i4;
            3'd5: d_out = i5;
            3'd6: d_out = i6;
            default: d_out = i7;
        endcase
endmodule
