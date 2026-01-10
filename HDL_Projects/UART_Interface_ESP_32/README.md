# UART Interface for ESP32

A complete UART (Universal Asynchronous Receiver/Transmitter) implementation for FPGA-ESP32 communication. This project provides bidirectional serial communication capabilities with loopback functionality for testing and data exchange.

## Features

- Full-duplex UART communication
- Configurable baud rate (implementation dependent)
- 8-bit data transmission
- Start and stop bit handling
- Data validity signaling
- Loopback mode for testing
- Seven-segment display integration (in complete system)

## Technologies Used

- Verilog HDL
- UART protocol implementation
- Synchronous digital design
- Xilinx Vivado Design Suite
- FPGA-ESP32 interfacing

## Hardware Requirements

- FPGA development board (Nexys-A7)
- ESP32 microcontroller
- UART connection (TX/RX pins)
- Serial terminal program for testing

## Implementation Details

### UART_RX Module
- Receives serial data from ESP32
- Detects start bit and samples data bits
- Generates validity signal when byte is complete
- Handles stop bit verification

### UART_TX Module
- Transmits data to ESP32
- Generates start bit, data bits, and stop bit
- Provides transmission active status
- Signals completion of transmission

### Top Module
- Integrates RX and TX modules
- Implements loopback: received data is immediately retransmitted
- Designed for serial terminal testing

## File Structure

- `UART_RX.v`: UART receiver implementation
- `UART_TX.v`: UART transmitter implementation
- `top_UART_RXTX.v`: Top-level integration with loopback
- Vivado project files

## Usage

1. Connect FPGA UART pins to ESP32 UART pins
2. Program FPGA with the design
3. Use serial terminal to send data to FPGA
4. Observe loopback response
5. Data can be displayed on seven-segment display (if integrated)

## Applications

- FPGA-ESP32 communication bridge
- Serial data processing
- Embedded system debugging
- IoT device interfacing
- Wireless sensor network gateway

## Learning Outcomes

This project demonstrates:
- Serial communication protocol implementation
- State machine design for protocol handling
- Timing-critical digital design
- FPGA-microcontroller interfacing
- Asynchronous data handling