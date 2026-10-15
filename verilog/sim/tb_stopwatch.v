`timescale 1ns / 1ps
// Testbench 2: the whole stopwatch (top module).
// Timers shortened so it runs fast (not powers of two - see README):
//   TICK_FINAL = 9     -> one hundredth = 10 clocks
//   DEBOUNCE_FINAL = 5 -> button sampled every 6 clocks
//   SCAN_FINAL = 9     -> 10 clocks per display digit
module tb_stopwatch;
    reg clk = 0, reset_n = 0, btnc = 0;
    wire [6:0] sseg; wire [0:7] AN; wire DP; wire [0:0] LED;
    integer errors = 0, paused_time;

    stopwatch #(.TICK_FINAL(9), .DEBOUNCE_FINAL(5), .SCAN_FINAL(9)) dut (
        .CLK100MHZ(clk), .CPU_RESETN(reset_n), .BTNC(btnc),
        .sseg(sseg), .AN(AN), .DP(DP), .LED(LED));

    always #5 clk = ~clk;

    // time on the stopwatch as 6 BCD digits, e.g. 24'h00_12_34 = 00.12.34
    wire [23:0] t = {dut.mm1, dut.mm0, dut.ss1, dut.ss0, dut.ff1, dut.ff0};

    task press;   // hold BTNC for 50 clocks, then let go
        begin
            btnc = 1; repeat (50) @(negedge clk);
            btnc = 0; repeat (50) @(negedge clk);
        end
    endtask

    task check(input [127:0] step, input expect_running, input pass);
        begin
            if (LED[0] !== expect_running || !pass) begin
                errors = errors + 1; $display("FAIL %0s: time %h, running %b", step, t, LED[0]);
            end else
                $display("  ok  %0s: time %h, running %b", step, t, LED[0]);
        end
    endtask

    initial begin
        $dumpfile("tb_stopwatch.vcd");
        $dumpvars(0, tb_stopwatch);

        repeat (3) @(negedge clk) reset_n = 1;
        repeat (500) @(negedge clk);
        check("idle", 0, t == 24'h00_00_00);                  // stays at 00.00.00

        press;                                                // start
        repeat (5_000) @(negedge clk);
        check("start", 1, t > 24'h00_00_00);                  // counting

        press;                                                // pause
        paused_time = t;
        repeat (2_000) @(negedge clk);
        check("pause", 0, t == paused_time);                  // frozen

        press;                                                // continue
        repeat (500) @(negedge clk);
        check("continue", 1, t > paused_time);                // counts on from paused value

        reset_n = 0; @(negedge clk) reset_n = 1;              // CPU reset
        repeat (500) @(negedge clk);
        check("reset", 0, t == 24'h00_00_00);

        if (errors == 0) $display("PASS: tb_stopwatch");
        else             $display("FAILED: %0d errors", errors);
        $finish;
    end
endmodule
