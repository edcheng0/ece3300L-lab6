`timescale 1ns / 1ps
// Six cascaded BCD digits: MM.SS.FF
//   ff0, ff1 : hundredths 00-99  (BCD_counter, mod 10)
//   ss0      : seconds ones 0-9  (BCD_counter)
//   ss1      : seconds tens 0-5  (mod_counter_input, FINAL_VALUE = 5)
//   mm0      : minutes ones 0-9  (BCD_counter)
//   mm1      : minutes tens 0-5  (mod_counter_input, FINAL_VALUE = 5)
// Same enable-chain idea as the provided multi_decade_counter:
// a digit counts only when every digit to its right is at its final value.
// 59.59.99 + one tick -> 00.00.00 (wraps around).
module stopwatch_counter(
    input        clk,
    input        reset_n,
    input        tick,             // one-clock pulse every 10 ms
    output [3:0] ff0, ff1,         // hundredths: ones, tens
    output [3:0] ss0, ss1,         // seconds:    ones, tens
    output [3:0] mm0, mm1          // minutes:    ones, tens
    );
    wire d_ff0, d_ff1, d_ss0, d_mm0;    // "at final value" flags
    wire e1, e2, e3, e4, e5;            // enables for each digit after the first

    BCD_counter FF0 (.clk(clk), .reset_n(reset_n), .enable(tick), .done(d_ff0), .Q(ff0));
    assign e1 = tick & d_ff0;

    BCD_counter FF1 (.clk(clk), .reset_n(reset_n), .enable(e1),   .done(d_ff1), .Q(ff1));
    assign e2 = e1 & d_ff1;

    BCD_counter SS0 (.clk(clk), .reset_n(reset_n), .enable(e2),   .done(d_ss0), .Q(ss0));
    assign e3 = e2 & d_ss0;

    mod_counter_input #(.BITS(4)) SS1 (
        .clk(clk), .reset_n(reset_n), .enable(e3), .FINAL_VALUE(4'd5), .Q(ss1));
    assign e4 = e3 & (ss1 == 4'd5);

    BCD_counter MM0 (.clk(clk), .reset_n(reset_n), .enable(e4),   .done(d_mm0), .Q(mm0));
    assign e5 = e4 & d_mm0;

    mod_counter_input #(.BITS(4)) MM1 (
        .clk(clk), .reset_n(reset_n), .enable(e5), .FINAL_VALUE(4'd5), .Q(mm1));
endmodule
