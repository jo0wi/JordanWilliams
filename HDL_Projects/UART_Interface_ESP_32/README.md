# UART Interface (ESP32 Bridge) — Nexys A7-100T (Verilog / Vivado)

A full-duplex UART loopback designed to bridge the Nexys A7 to an ESP32 over a TX/RX pair. Bytes received on `UART_TXD_IN` are immediately retransmitted on `UART_RXD_OUT`, allowing the FPGA to act as a transparent echo / pass-through node between an ESP32 (or any other UART peer) and a serial terminal during board bring-up.

> **Note:** The receiver and transmitter cores were originally developed for the standalone [UART Transceiver](../uart%20transceiver/) project. This project re-instantiates them with FPGA pins routed to ESP32 UART headers instead of the onboard USB-UART bridge.

---

## Project Structure

| File | Description |
|------|-------------|
| `sources_1/imports/new/top_UART_RXTX.v` | Top — wires RX -> TX, gates the line idle-high when TX is inactive |
| `sources_1/imports/new/UART_RX.v` | 4-state FSM receiver (IDLE -> START -> DATA -> STOP) |
| `sources_1/imports/new/UART_TX.v` | 4-state FSM transmitter (IDLE -> START -> DATA -> STOP) |
| `Nexys-A7-100T-Master.xdc` (parent) | Pin constraints — re-route `UART_TXD_IN` / `UART_RXD_OUT` to PMOD pins for ESP32 wiring |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| FPGA Board | Nexys A7-100T (Artix-7) |
| Companion MCU | ESP32 (any 3.3 V UART-capable peer works) |
| System Clock | 100 MHz |
| Baud Rate | 115200 (8N1) |
| Clocks per Bit | 868 (100 MHz / 115200) |
| Sample point | Mid-bit (clocks 433 / 868) — rejects start-bit glitches |
| Tool | Vivado |
| Language | Verilog |

---

## How It Works

**RX FSM.** Watches the line for a falling edge (start bit), waits to the midpoint to confirm the line is still low, then samples each of the 8 data bits LSB-first at 868-clock intervals. After the stop bit it pulses `RX_valid` for one clock and presents the byte on `RX_data`.

**TX FSM.** Mirror of the receiver. When `TX_valid` is asserted it latches `TX_byte`, drives `TX_line` low for one bit period (start), shifts out the eight data bits, and finishes with a high stop bit, holding `TX_active` high for the duration.

**Echo Loop.** The top module ties `RX_valid -> TX_valid` and `RX_data -> TX_byte`, so a complete received byte triggers an immediate retransmission. While the transmitter is idle the output line is forced to logic 1 (`UART_RXD_OUT = TX_active ? TX_line : 1'b1`) to keep the line in the UART idle (mark) state.

---

## How to Run

1. Open the project in Vivado and verify the top is `top_UART_RXTX`.
2. Edit the XDC so that `UART_TXD_IN` and `UART_RXD_OUT` are mapped to PMOD pins wired to the ESP32 (TX -> RX and RX -> TX, common ground).
3. Run **Synthesis -> Implementation -> Generate Bitstream** and program the board.
4. Flash a UART echo / printf sketch on the ESP32 at 115200 baud and verify each byte is round-tripped through the FPGA.

## Applications

- ESP32 <-> FPGA bring-up bridge — confirm pin mapping and baud-rate alignment before adding application logic.
- Sniffer / pass-through node when paired with a logic analyzer.
- Skeleton for FPGA-side framing / parsing on top of the bare echo path.
