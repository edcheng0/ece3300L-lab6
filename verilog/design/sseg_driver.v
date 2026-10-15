`timescale 1ns / 1ps
// From Lab 5: time-multiplexed 8-digit seven-segment driver.
// Each input word: [5]=enable, [4:1]=hex digit, [0]=DP (active-low, 0 = dot on).
// i0 is the rightmost digit (AN0), i7 the leftmost (AN7).
module sseg_driver
    #(parameter FINAL_VALUE = 99_999)(   // 1 ms/digit -> 8 ms frame (125 Hz)
    input        clk,
    input        reset_n,
    input  [5:0] i0, i1, i2, i3, i4, i5, i6, i7,
    output [6:0] sseg,
    output [0:7] AN,
    output       DP
    );
    wire       done;
    wire [2:0] count_out;
    wire [5:0] d_out;
    wire [0:7] y;

    timer_parameter #(.FINAL_VALUE(FINAL_VALUE)) timer (
        .clk(clk), .reset_n(reset_n), .enable(1'b1), .done(done));

    udl_counter #(.BITS(3)) cnt (
        .clk(clk), .reset_n(reset_n), .enable(done),
        .up(1'b1), .load(1'b0), .D(3'b000), .Q(count_out));

    mux_8x1_6bit mux (
        .i0(i0), .i1(i1), .i2(i2), .i3(i3), .i4(i4), .i5(i5), .i6(i6), .i7(i7),
        .s(count_out), .d_out(d_out));

    decoder_generic #(.N(3)) dec (.w(count_out), .en(d_out[5]), .y(y));
    assign AN = ~y;                       // one inversion: active-low anodes

    hex2sseg h2s (.hex(d_out[4:1]), .sseg(sseg));   // already active-low
    assign DP = d_out[0];                 // straight through
endmodule
