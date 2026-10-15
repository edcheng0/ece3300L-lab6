`timescale 1ns / 1ps
// Testbench 1: MM.SS.FF counter chain.
// tick is held high, so the time goes up by one hundredth every clock.
module tb_stopwatch_counter;
    reg clk = 0, reset_n = 0, tick = 0;
    wire [3:0] ff0, ff1, ss0, ss1, mm0, mm1;
    integer errors = 0;

    stopwatch_counter dut (
        .clk(clk), .reset_n(reset_n), .tick(tick),
        .ff0(ff0), .ff1(ff1), .ss0(ss0), .ss1(ss1), .mm0(mm0), .mm1(mm1));

    always #5 clk = ~clk;

    // compare the display digits with an expected MM.SS.FF (written as 6 BCD digits)
    task check(input [23:0] expected);
        if ({mm1, mm0, ss1, ss0, ff1, ff0} !== expected) begin
            errors = errors + 1;
            $display("FAIL: got %h, expected %h", {mm1, mm0, ss1, ss0, ff1, ff0}, expected);
        end else
            $display("  ok  %h", expected);
    endtask

    initial begin
        $dumpfile("tb_stopwatch_counter.vcd");
        $dumpvars(0, tb_stopwatch_counter);
        @(negedge clk) reset_n = 1;
        check(24'h00_00_00);

        tick = 1;
        repeat (12_345)  @(negedge clk);  check(24'h02_03_45);  // 12,345 cs = 2 min 3.45 s
        repeat (347_654) @(negedge clk);  check(24'h59_59_99);  // 359,999 cs = max value
        repeat (1)       @(negedge clk);  check(24'h00_00_00);  // wraps around
        tick = 0;
        repeat (10)      @(negedge clk);  check(24'h00_00_00);  // holds when tick = 0

        if (errors == 0) $display("PASS: tb_stopwatch_counter");
        else             $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule
