# UART Echoing Transceiver

A complete UART (Universal Asynchronous Receiver/Transmitter) implementation on FPGA featuring bidirectional serial communication with real-time hexadecimal display. This project demonstrates advanced digital communication protocols, state machine design, and hardware-software interfacing.

## Features

- **Full-Duplex UART Communication**: Simultaneous transmit and receive at 115,200 baud
- **Real-Time Hexadecimal Display**: 2-digit seven-segment display showing received byte values
- **Echo Functionality**: Automatically retransmits received data for verification
- **Modular Design**: Separate RX, TX, and display modules for clean architecture
- **Clock Domain Management**: Proper clock division for display multiplexing
- **Error Handling**: Start/stop bit validation and framing error detection

## Technologies Used

- **HDL**: Verilog
- **FPGA Platform**: Xilinx Nexys A7-100T (Artix-7)
- **Development Tools**: Vivado Design Suite
- **Communication Protocol**: UART (RS-232 serial)
- **Display Interface**: Multiplexed seven-segment display

## Hardware Requirements

- Nexys A7-100T FPGA development board
- USB-to-UART bridge (integrated on board)
- Serial terminal software (PuTTY, Tera Term, etc.)
- Seven-segment display (8 digits, common cathode)

## Implementation Details

### UART Receiver (UART_RX.v)
Implements a robust UART receiver with precise timing control:

- **Baud Rate**: 115,200 bps (868 clock cycles per bit at 100 MHz)
- **Data Format**: 8 data bits, 1 start bit, 1 stop bit, no parity
- **State Machine**: 4-state FSM (IDLE → START → DATA → STOP)
- **Sampling**: Mid-bit sampling for noise immunity
- **Timing**: Synchronous design with counter-based bit timing

### UART Transmitter (UART_TX.v)
Complementary transmitter module with matching protocol:

- **State Machine**: 4-state FSM with active transmission tracking
- **Bit Ordering**: LSB-first transmission
- **Flow Control**: TX_active flag prevents data corruption
- **Completion Signaling**: TX_done pulse on transmission complete

### Seven-Segment Display Driver (hex_to_ssd_2digit.v)
Intelligent display controller for hexadecimal visualization:

- **Multiplexing**: Time-division multiplexing for 2-digit display
- **Clock Division**: 60 kHz refresh rate from 100 MHz system clock
- **Encoding**: Full hexadecimal character set (0-F)
- **Control**: Active-low segment and anode control signals

### Clock Divider
Generates appropriate clock frequencies for different subsystems from the 100 MHz system clock.

## File Structure

- `top_UART_RXTX.v`: Top-level integration module
- `UART_RX.v`: UART receiver implementation
- `UART_TX.v`: UART transmitter implementation
- `hex_to_ssd_2digit.v`: Seven-segment display driver
- `uart transceiver.xdc`: Pin constraints for Nexys A7
- Vivado project files (.xpr, .cache, .hw, .runs, .srcs)

## Setup and Usage

### Hardware Setup
1. Connect Nexys A7 to computer via USB
2. Ensure FPGA is programmed with the bitstream

### Software Setup
1. Open serial terminal (PuTTY recommended)
2. Connect to the FPGA's COM port at:
   - **Baud Rate**: 115,200
   - **Data Bits**: 8
   - **Stop Bits**: 1
   - **Parity**: None
   - **Flow Control**: None

### Operation
1. Type any character in the terminal
2. Observe the hexadecimal value displayed on the seven-segment display
3. Verify the character is echoed back in the terminal
4. Press board reset to clear the display

## Timing Analysis

- **System Clock**: 100 MHz
- **UART Baud Rate**: 115,200 bps
- **Clocks per Bit**: 868 (100,000,000 ÷ 115,200)
- **Display Refresh**: 60 kHz (multiplexing frequency)
- **Bit Sampling**: Mid-bit sampling for reliability

## Applications

- Serial communication debugging and testing
- FPGA-microcontroller interfacing
- Embedded system development tools
- Protocol analysis and verification
- Educational UART implementation reference

## Learning Outcomes

This project demonstrates expertise in:
- **Serial Communication Protocols**: UART implementation from scratch
- **State Machine Design**: Complex FSM for protocol handling
- **Timing-Critical Design**: Precise clock cycle counting
- **Hardware Interfacing**: Seven-segment display control
- **Modular Design**: Clean separation of concerns
- **FPGA Development Workflow**: Synthesis, implementation, and programming

## Future Enhancements

- Add parity bit support
- Implement configurable baud rates
- Add FIFO buffers for higher throughput
- Include error detection and correction
- Add flow control (RTS/CTS)
- Create testbench for automated verification