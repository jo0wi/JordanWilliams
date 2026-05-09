# Primitive Gates Implementation

A collection of basic digital logic gates implemented in Verilog HDL. This project demonstrates fundamental gate-level design and testbench development for verification.

## Features

- 2-input AND gate implementation
- 2-input OR gate implementation
- Comprehensive testbenches for each gate
- Behavioral modeling
- Timing simulation support

## Technologies Used

- Verilog HDL
- Xilinx Vivado Design Suite
- Digital logic simulation
- Testbench development

## Gate Specifications

### AND2_Gate
- Inputs: A, B
- Output: Y = A & B
- Truth table:
  - 00 → 0
  - 01 → 0
  - 10 → 0
  - 11 → 1

### OR2_Gate
- Inputs: A, B
- Output: Y = A | B
- Truth table:
  - 00 → 0
  - 01 → 1
  - 10 → 1
  - 11 → 1

## File Structure

- `AND2_Gate.v`: AND gate implementation
- `OR2_Gate.v`: OR gate implementation
- `AND2gate_tb.v`, `AND2_Gate.tb`: AND gate testbenches
- `OR2_Gate_tb.v`: OR gate testbench
- Vivado project files

## Simulation

1. Open project in Vivado
2. Add testbench files to simulation set
3. Run behavioral simulation
4. Analyze waveforms for correct gate operation

## Learning Outcomes

This project covers:
- Basic Verilog syntax and structure
- Combinational logic design
- Testbench creation and stimulus generation
- Waveform analysis
- Digital logic verification techniques