# Seven Segment Counter Display

A synchronous hexadecimal to seven-segment display encoder designed for counter and timer applications. This module converts 4-bit binary values to seven-segment display patterns with clocked operation.

## Features

- Synchronous 4-bit to seven-segment conversion
- Hexadecimal digit support (0-F)
- Clocked design for timing control
- Common cathode display format

## Technologies Used

- Verilog HDL
- Synchronous digital design
- Xilinx Vivado Design Suite
- FPGA implementation

## Hardware Requirements

- FPGA development board
- Seven-segment display
- Clock source
- 4-bit data input (from counter, switches, etc.)

## Implementation Details

The module uses a synchronous always block triggered on the positive clock edge to update the seven-segment output based on the 4-bit binary input. Each hex digit is mapped to its corresponding segment pattern.

### Segment Encoding
- Uses 7-bit register for segment control
- Active high for LED illumination
- Standard hexadecimal patterns

## File Structure

- `binary_to_7sd.v`: Seven-segment encoder with clock synchronization
- `clock_7sd.v`: Additional clock-related module (may be incomplete)
- Vivado project files

## Usage

```verilog
binary_to_7sd display_driver(
    .clk(system_clock),
    .bin_num(counter_value),
    .A(segA), .B(segB), .C(segC),
    .D(segD), .E(segE), .F(segF), .G(segG)
);
```

## Applications

- Digital counter displays
- Timer circuits
- Hexadecimal value visualization
- Debug output displays

## Learning Outcomes

This project demonstrates:
- Synchronous logic design
- Combinational logic in sequential contexts
- Seven-segment display interfacing
- Clock domain design
- Hexadecimal encoding schemes