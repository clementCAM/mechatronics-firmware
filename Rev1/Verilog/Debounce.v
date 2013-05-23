/*******************************************************************************
 *
 * Copyright(C) 2008 ERC CISST, Johns Hopkins University.
 *
 * Debouncer works by changing the output only when the input remains steady
 * for a number of clock cycles (number of bits in the shift register).
 *
 * Select a clock frequency and shift register size based on need.  This acts
 * like a lowpass filter.  Lower frequency and/or larger register results in a
 * lower cutoff frequency with greater in-to-out delay (and vice versa).
 *
 * Revision history
 *     05/20/08    Paul Thienphrapa    Initial revision
 */
module Debounce(clk, reset, sig_in, sig_out);

    // define I/Os
    input clk;                   // clock to use for debouncing
    input reset;                 // global reset signal
    input sig_in;                // raw signal input
    output sig_out;              // debounced signal output

    // local wires and registers
    reg sig_out;                 // cleaned registered output
    reg[bits-1:0] sig_shift;     // input signal shift register
    wire[bits-1:0] all_zeros;    // vector of all zeros
    wire[bits-1:0] all_ones;     // vector of all ones

    // # of consecutive bits required for a signal transition
    parameter bits = 9;


// seems like this helps the synthesizer
assign all_zeros = 0;
assign all_ones = ~0;

// shift register for storing input signal
always @(posedge(clk))
    sig_shift <= { sig_shift[bits-2:0], sig_in };

// output signal follows input only when shift register filled uniformally
always @(posedge(clk) or negedge(reset))
begin
    if (reset == 0)
        sig_out <= 0;
    else if ((sig_shift==all_zeros) || (sig_shift==all_ones))
        sig_out <= sig_shift[bits-1];
end

endmodule

