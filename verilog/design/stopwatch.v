`timescale 1ns / 1ps
// Lab 6 TOP MODULE: stopwatch on the Nexys A7-100T.
//   Display (8 digits):  _ _ M M . S S . F F     (two leftmost digits blank)
//   BTNC       : start / pause / continue (toggles run each press)
//   CPU_RESETN : reset to 00.00.00 and stop
//   LED[0]     : on while running (extra, handy for the demo)
module stopwatch
    #(parameter TICK_FINAL     = 999_999,   // 1,000,000 x 10 ns = 10 ms  -> hundredths
      parameter DEBOUNCE_FINAL = 499_999,   // 5 ms button sampling
      parameter SCAN_FINAL     = 99_999)(   // 1 ms per digit on the display
    input        CLK100MHZ,
    input        CPU_RESETN,
    input        BTNC,
    output [6:0] sseg,
    output [0:7] AN,
    output       DP,
    output [0:0] LED
    );
    wire clk = CLK100MHZ;
    wire reset_n = CPU_RESETN;

    // ---------- start / pause / continue ----------
    wire pressed;
    reg  run;

    btn_debounce #(.SAMPLE_FINAL(DEBOUNCE_FINAL)) btnc_db (
        .clk(clk), .reset_n(reset_n), .btn_in(BTNC), .pressed(pressed));

    always @(posedge clk, negedge reset_n)
        if (~reset_n)
            run <= 1'b0;
        else if (pressed)
            run <= ~run;              // toggle

    assign LED[0] = run;

    // ---------- 10 ms time base ----------
    // The timer only advances while running, so pausing keeps the partial
    // hundredth and continuing picks up exactly where it stopped.
    wire done_10ms, tick;

    timer_parameter #(.FINAL_VALUE(TICK_FINAL)) tick_timer (
        .clk(clk), .reset_n(reset_n), .enable(run), .done(done_10ms));

    assign tick = run & done_10ms;    // gate: done stays high if paused on the final count

    // ---------- MM.SS.FF counter chain ----------
    wire [3:0] ff0, ff1, ss0, ss1, mm0, mm1;

    stopwatch_counter cnt (
        .clk(clk), .reset_n(reset_n), .tick(tick),
        .ff0(ff0), .ff1(ff1), .ss0(ss0), .ss1(ss1), .mm0(mm0), .mm1(mm1));

    // ---------- display (Lab 5 driver) ----------
    // word = {enable, digit[3:0], DP_n}   DP_n = 0 lights the decimal point
    sseg_driver #(.FINAL_VALUE(SCAN_FINAL)) display (
        .clk(clk), .reset_n(reset_n),
        .i0({1'b1, ff0, 1'b1}),     // F (ones)
        .i1({1'b1, ff1, 1'b1}),     // F (tens)
        .i2({1'b1, ss0, 1'b0}),     // S (ones) + decimal point  -> SS.FF
        .i3({1'b1, ss1, 1'b1}),     // S (tens)
        .i4({1'b1, mm0, 1'b0}),     // M (ones) + decimal point  -> MM.SS
        .i5({1'b1, mm1, 1'b1}),     // M (tens)
        .i6(6'b0_0000_1),           // blank
        .i7(6'b0_0000_1),           // blank
        .sseg(sseg), .AN(AN), .DP(DP));
endmodule
