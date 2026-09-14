# 16-Tap FIR Filter in SystemVerilog

This project is intended to implement a finite impulse response (FIR) digital
filter with 16 taps. The filter accepts 16-bit input samples and uses one
16-bit coefficient for each tap. Fixed-point values are supported so that the
design can be synthesized for FPGA or ASIC hardware without floating-point
arithmetic.

## Project Status

The repository currently contains the initial SystemVerilog module template
and an empty testbench. The RTL interface, arithmetic width, clocking behavior,
and verification environment still need to be implemented.

## Intended Filter Operation

For an input sample sequence `x[n]` and coefficients `h[0]` through `h[15]`,
the output is:

```text
y[n] = h[0]x[n] + h[1]x[n-1] + ... + h[15]x[n-15]
```

The implementation will maintain a delay line containing the most recent 16
input samples. On each accepted sample, the filter will multiply every sample
in the delay line by its corresponding coefficient and accumulate the 16
products.

## Data and Fixed-Point Format

- Input sample: 16-bit signed fixed-point value
- Coefficient: 16-bit signed fixed-point value for each of 16 taps
- Number of taps: 16
- Product width: 32 bits before accumulation
- Accumulator: wider than 32 bits to reduce overflow risk during summation
- Output: 16-bit signed fixed-point value after scaling and saturation or
	truncation, depending on the selected implementation

The binary-point location must be defined consistently for both samples and
coefficients. For example, with Q1.15 inputs and coefficients:

```text
Q1.15 x Q1.15 = Q2.30
```

The accumulated result must then be shifted right by 15 bits to return to a
Q1.15 output. Any narrowing operation should specify whether it truncates,
rounds, or saturates.

## Planned Hardware Interface

The final module interface should define, at minimum:

- `clk`: rising-edge clock
- `rst`: reset input for clearing the delay line and output state
- `valid_in`: indicates that `sample_in` is valid
- `sample_in`: signed 16-bit input sample
- `coefficients`: 16 signed 16-bit tap coefficients, or an equivalent
	coefficient-load interface
- `valid_out`: indicates that `sample_out` is valid
- `sample_out`: signed 16-bit filtered output

The exact signal names and whether coefficients are parameters, ports, or
runtime-programmable registers will be decided when the RTL is completed.

## Expected Processing Behavior

1. Reset clears all 16 delay-line entries and the output state.
2. When `valid_in` is asserted, the new sample enters the delay line.
3. The 16 delayed samples are multiplied by the 16 coefficients.
4. The products are accumulated using signed arithmetic.
5. The accumulator is scaled back to the output fixed-point format.
6. The result is presented on `sample_out` with `valid_out` asserted.

The latency will depend on whether the multiplier-accumulator is implemented as
a single combinational sum, a pipelined adder tree, or a sequential MAC unit.

## Files

| File | Description |
| --- | --- |
| `FIR.sv` | FIR filter RTL; currently a module template |
| `FIR_tb.sv` | Simulation testbench; currently empty |
| `README.md` | Project description and fixed-point design notes |

## Verification Plan

The testbench should verify:

- Reset behavior and delay-line initialization
- Impulse response, which should reproduce the coefficient sequence
- Constant and ramp input sequences
- Positive and negative signed samples and coefficients
- Fixed-point scaling and output width conversion
- Overflow, rounding, and saturation behavior
- Input/output valid timing and filter latency

A useful reference model is the same convolution equation evaluated with a
wide signed integer accumulator. Simulation should compare the RTL output
against this model for each valid input sample.

## Simulation

No simulator command is configured yet. Once the RTL and testbench are
implemented, run them with a SystemVerilog simulator such as Questa,
Vivado XSim, Verilator, or Icarus Verilog, and add the project-specific
compile and run commands here.
