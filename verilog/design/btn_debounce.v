`timescale 1ns / 1ps
// Push-button conditioner: synchronize -> debounce -> one-clock pulse on press.
//  1. Two flip-flops synchronize the raw button to the 100 MHz clock.
//  2. The synchronized level is sampled only once every (SAMPLE_FINAL+1) clocks
//     (default 500,000 clocks = 5 ms). Contact bounce lasts less than that,
//     so the sampled level changes at most once per real press.
//  3. The provided button.v turns the clean level into a single-clock pulse.
module btn_debounce
    #(parameter SAMPLE_FINAL = 499_999)(  // 5 ms at 100 MHz
    input  clk,
    input  reset_n,
    input  btn_in,       // raw button pin (active-high on the Nexys A7)
    output pressed       // one-clock pulse per press
    );
    reg sync0, sync1, level;
    wire sample;

    always @(posedge clk) begin
        sync0 <= btn_in;
        sync1 <= sync0;
    end

    timer_parameter #(.FINAL_VALUE(SAMPLE_FINAL)) sample_timer (
        .clk(clk), .reset_n(reset_n), .enable(1'b1), .done(sample));

    always @(posedge clk, negedge reset_n)
        if (~reset_n)
            level <= 1'b0;
        else if (sample)
            level <= sync1;

    // provided starter module: rising-edge detector
    button edge_det (.clk(clk), .in(level), .out(pressed));
endmodule
