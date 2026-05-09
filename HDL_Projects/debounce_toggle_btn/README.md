# Debounced Toggle Button

An FPGA project implementing a debounced toggle button with LED output. This design demonstrates digital signal processing techniques for handling mechanical button bounce and state machine design for toggle functionality.

## Features

- Mechanical button debouncing (1ms filter)
- Toggle LED on button press
- Edge detection for press events
- Synchronous design with clock domain

## Technologies Used

- Verilog HDL
- Xilinx Vivado Design Suite
- FPGA synthesis and implementation
- Nexys-A7 development board

## Hardware Requirements

- Nexys-A7 FPGA board
- Push button switch
- LED for output indication

## Implementation Details

### Debounce Module
- Uses a 27-bit counter for timing
- Filters out bounces for 1ms at 100 MHz clock
- Synchronous state machine design

### Toggle Module
- Detects falling edge of debounced button signal
- Toggles LED state on each valid press
- Prevents multiple toggles during single press

## File Structure

- `debounce_btn.v`: Debouncing logic implementation
- `toggle_btn.v`: Toggle functionality and top-level integration
- Vivado project files (.xpr, .cache, .hw, .runs, .srcs)

## Key Parameters

- Clock frequency: 100 MHz
- Debounce time: 1 ms (1,000,000 clock cycles)
- Counter width: 27 bits

## Synthesis and Implementation

1. Open the project in Xilinx Vivado
2. Run Synthesis
3. Run Implementation
4. Generate Bitstream
5. Program the FPGA

## Learning Outcomes

This project covers:
- Digital filtering techniques
- Edge detection circuits
- State machine design
- Module instantiation and hierarchy
- Timing constraints for reliable operation