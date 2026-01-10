# Seven Segment Display Decoder

A Verilog implementation of a hexadecimal to seven-segment display decoder. This module converts 4-bit binary input to the appropriate seven-segment display pattern for hexadecimal digits (0-F).

## Features

- 4-bit binary to seven-segment conversion
- Hexadecimal digit support (0-9, A-F)
- Common cathode display configuration
- Combinational logic design

## Technologies Used

- Verilog HDL
- Xilinx Vivado Design Suite
- Digital logic design
- Seven-segment display interfacing

## Hardware Requirements

- Seven-segment display (common cathode)
- FPGA development board with display interface
- 4-bit input source (switches, counters, etc.)

## Implementation Details

The decoder uses a lookup table approach with a case statement to map each 4-bit input value to the corresponding seven-segment pattern. Each segment (A-G) is individually controlled.

### Segment Mapping
- A: Top segment
- B: Upper right
- C: Lower right
- D: Bottom
- E: Lower left
- F: Upper left
- G: Middle

### Truth Table
- 0000 (0): 1111110
- 0001 (1): 0110000
- 0010 (2): 1101101
- ... (continues for all hex digits)

## File Structure

- `Binary_Ssd.v`: Seven-segment decoder implementation
- Vivado project files

## Usage

```verilog
Decoder7Seg decoder(
    .In3(input[3]),
    .In2(input[2]),
    .In1(input[1]),
    .In0(input[0]),
    .A(segA),
    .B(segB),
    .C(segC),
    .D(segD),
    .E(segE),
    .F(segF),
    .G(segG),
    .SegSel(display_enable)
);
```

## Learning Outcomes

This project demonstrates:
- Combinational logic design
- Lookup table implementation in HDL
- Seven-segment display interfacing
- Hexadecimal encoding
- FPGA output pin mapping