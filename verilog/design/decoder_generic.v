`timescale 1ns / 1ps
// N-to-2^N decoder with enable, active-high outputs. y[k] = 1 when w == k and en = 1.
// Same interface as the Lab 5 starter module - use your Lab 5 copy if you have it.
module decoder_generic
    #(parameter N = 3)(
    input      [N - 1:0]      w,
    input                     en,
    output reg [0:2**N - 1]   y
    );
    always @(*) begin
        y = 'b0;
        if (en)
            y[w] = 1'b1;
    end
endmodule
