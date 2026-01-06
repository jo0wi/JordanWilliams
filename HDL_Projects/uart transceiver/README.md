# 📡 UART Echoing Transceiver (FPGA – Nexys A7 Board)

![Nexys A7 Board Setup](./docs/Nexys_A7_Setup.jpg)

### 🎯 Overview
This project implements a **UART Transceiver** on the **Nexys A7-100T FPGA development board**, written in **Verilog HDL**.  
The system receives ASCII data from a serial terminal over USB, displays the received byte's hexadecimal value on a **7-segment display**, and echoes the data back to the terminal.

Designed with modular UART receiver and transmitter modules, it demonstrates serial communication, data processing, and hardware interfacing.

---

## ⚙️ Features
✅ Receives UART data at **115200 baud** from serial terminal  
✅ Displays received byte in **hexadecimal** on 7-segment display (2 digits)  
✅ Echoes received data back to terminal for verification  
✅ Handles start/stop bits and data framing  
✅ Multiplexed 7-segment display with active-low control  
✅ Reset functionality for initialization  

---
## 🧰 Tools Used
- **HDL / Simulation:**	Verilog
- **Synthesis / Implementation:** Vivado 2023.x
- **Hardware:**	Nexys A7-100T FPGA, USB-UART bridge

---

## 🧩 Design Overview

### 📥 UART_RX (Receiver Module)
Implements UART reception with state machine:

| State | Description |
|-------|--------------|
| **IDLE** | Waits for start bit (low) |
| **START** | Verifies start bit and samples midpoint |
| **DATA** | Receives 8 data bits (LSB first) |
| **STOP** | Verifies stop bit (high) and sets valid flag |

**Inputs:** `Clk`, `RX_line`  
**Outputs:** `RX_valid`, `RX_data[7:0]`

### 📤 UART_TX (Transmitter Module)
Implements UART transmission with state machine:

| State | Description |
|-------|--------------|
| **IDLE** | Waits for valid data to transmit |
| **START** | Sends start bit (low) |
| **DATA** | Sends 8 data bits (LSB first) |
| **STOP** | Sends stop bit (high) and signals done |

**Inputs:** `Clk`, `Rst`, `TX_valid`, `TX_byte[7:0]`  
**Outputs:** `TX_active`, `TX_line`, `TX_done`

### 🖥️ hex_to_ssd (Display Module)
Drives 7-segment display for hexadecimal output:

- Multiplexes between upper and lower nibbles
- Active-low segment and anode control
- Updates on valid RX data

**Inputs:** `ClkOut`, `RX_data[7:0]`, `RX_valid`  
**Outputs:** `A-G`, `AN[7:0]`

### ⏱️ ClkDiv (Clock Divider)
Generates slower clocks for display multiplexing from 100MHz system clock.

---

## 🔧 Setup and Usage
1. **Synthesize and Program:** Open in Vivado, synthesize, and program Nexys A7 board.
2. **Connect Serial Terminal:** Use PuTTY or similar, connect to board's USB COM port at 115200 baud.
3. **Send Data:** Type characters in terminal; board displays hex on 7-segment and echoes back.
4. **Reset:** Press board reset to clear display.

---

## 📊 Block Diagram
```
Serial Terminal <-> USB <-> UART_RX -> hex_to_ssd -> 7-Segment Display
                      |                ^
                      v                |
                   UART_TX <-----------
```

---

## 🐛 Debugging Tips
- **No Display:** Check pin constraints in `.xdc` file.
- **Wrong Data:** Verify UART timing (868 cycles/bit at 100MHz).
- **Echo Issues:** Ensure TX/RX lines are correctly connected in top module.

---
**Note:** Ensure correct pin mappings for Nexys A7 UART and 7-segment pins in constraints file.