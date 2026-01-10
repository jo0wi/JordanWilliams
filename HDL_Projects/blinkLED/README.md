# LED Blinker

A basic FPGA project that implements a PWM generator to blink an LED at 1 Hz. This project demonstrates fundamental digital design concepts including clock division and output control.

## Features

- 1 Hz LED blinking frequency
- PWM-based implementation
- Configurable timing parameters
- Synchronous design

## Technologies Used

- Verilog HDL
- Xilinx Vivado Design Suite
- FPGA synthesis and implementation
- Nexys-A7 development board

## Hardware Requirements

- Nexys-A7 FPGA board
- LED connected to appropriate pin (configured in constraints)

## Implementation Details

The design uses a counter that increments on each clock cycle. When the counter reaches half the desired cycle count (50,000,000 for 100 MHz clock), the LED state is toggled, creating a 1 Hz blink rate.

### Key Parameters

- Clock frequency: 100 MHz
- Target blink frequency: 1 Hz
- Half cycle count: 50,000,000

## File Structure

- `blinkLED.v`: Main Verilog module
- `blinkLED.xdc`: Pin constraints (in parent directory)
- Vivado project files (.xpr, .cache, .hw, .runs, .srcs)

## Synthesis and Implementation

1. Open the project in Xilinx Vivado
2. Run Synthesis
3. Run Implementation
4. Generate Bitstream
5. Program the FPGA

## Learning Outcomes

This project covers:
- Basic Verilog module structure
- Clock domain design
- Counter implementation
- FPGA pin constraints
- Timing analysis basics