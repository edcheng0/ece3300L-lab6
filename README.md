# ece3300L-lab6 : Stopwatch
## Files
### Design
- [`src/BCD_counter.v`](verilog/design/BCD_counter.v) – starter: BCD (mod-10) counter
- [`src/mod_counter_input.v`](verilog/design/mod_counter_input.v) – starter: modulus counter with input final value
- [`src/timer_parameter.v`](verilog/design/timer_parameter.v) – starter: parameterized timer
- [`src/udl_counter.v`](verilog/design/udl_counter.v) – starter: up/down/load counter
- [`src/button.v`](verilog/design/button.v) – starter: button edge detector
- [`src/stopwatch.v`](verilog/design/stopwatch.v) – top module
- [`src/stopwatch_counter.v`](verilog/design/stopwatch_counter.v) – MM.SS.FF counter chain
- [`src/btn_debounce.v`](verilog/design/btn_debounce.v) – button synchronizer and debouncer
- [`src/sseg_driver.v`](verilog/design/sseg_driver.v) – Lab 5: 8-digit seven-segment driver
- [`src/mux_8x1_6bit.v`](verilog/design/mux_8x1_6bit.v) – Lab 5: 8x1 mux, 6-bit
- [`src/decoder_generic.v`](verilog/design/decoder_generic.v) – Lab 5: parameterized decoder
- [`src/hex2sseg.v`](verilog/design/hex2sseg.v) – Lab 5: hex to seven-segment converter
### Sim
- [`tb/tb_stopwatch_counter.v`](verilog/sim/tb_stopwatch_counter.v) – counter chain testbench
- [`tb/tb_stopwatch.v`](verilog/sim/tb_stopwatch.v) – top-module testbench
### Constraints
- [`constraints/stopwatch.xdc`](verilog/constraints/stopwatch.xdc) – board constraints, Nexys A7-100T
## Stopwatch
Simulation waveforms:
![Counter wrap 59.59.99 to 00.00.00](screenshots/tb_stopwatch_counter_wrap.png)
![Start](screenshots/tb_stopwatch_start.png)
![Pause](screenshots/tb_stopwatch_pause.png)
![Display scan](screenshots/tb_stopwatch_display.png)
Schematic:
![Stopwatch schematic](screenshots/stopwatch_schematic.png)
Block diagram:
![Stopwatch block diagram](screenshots/stopwatch_blockdiagram.png)
## Demo
[Stopwatch demo video](videos/stopwatch_demo.mp4)
