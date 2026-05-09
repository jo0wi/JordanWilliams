# 4-Bit Up/Down Counter

A synchronous 4-bit up/down counter implemented in Verilog HDL. This digital circuit counts up or down based on control inputs and demonstrates sequential logic design principles.

## Features

- 4-bit synchronous counter (0-15 range)
- Up/Down counting modes
- Enable control for counting
- Asynchronous reset
- Wrap-around functionality

## Technologies Used

- Verilog HDL
- Synchronous digital design
- Xilinx Vivado Design Suite
- FPGA implementation

## Hardware Requirements

- FPGA development board
- Clock input
- Control switches/buttons for UpDown, Enable, Reset
- Output display (LEDs or seven-segment)

## Implementation Details

### Control Signals
- **Clk**: Clock input for synchronous operation
- **Rst**: Asynchronous reset (active high)
- **Enable**: Counting enable (active high)
- **UpDown**: Direction control (1=up, 0=down)

### Operation
- When Enable=1 and UpDown=1: Count up (0→1→2→...→15→0)
- When Enable=1 and UpDown=0: Count down (15→14→...→0→15)
- When Enable=0: Hold current count
- When Rst=1: Reset to 0

## File Structure

- `UpDownCounter_4bit.v`: Counter logic implementation
- `UD_Counter_Top.v`: Top-level module with I/O mapping
- Vivado project files

## Usage

```verilog
UpDownCounter_4bit counter(
    .Clk(clock),
    .Rst(reset),
    .Enable(count_enable),
    .UpDown(direction),
    .Cnt(count_output)
);
```

## Learning Outcomes

This project covers:
- Synchronous counter design
- Control signal integration
- State machine concepts in counters
- Verilog always blocks and conditional logic
- FPGA timing constraints