# LED Blinker — Nexys A7-100T (Verilog / Vivado)

A minimal Verilog module that toggles an FPGA LED at 1 Hz by dividing the 100 MHz system clock with a free-running counter. Used as the introductory "hello world" for the Vivado synthesis-implementation-bitstream flow on the Nexys A7-100T.

---

## Project Structure

| File | Description |
|------|-------------|
| `blinkLED.srcs/sources_1/new/blinkLED.v` | `PWM_generator` module — 100 MHz / 100 M counter that toggles `LED` at the rollover |
| `Nexys-A7-100T-Master.xdc` (parent dir) | Pin constraints (LED -> onboard LD0) |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| FPGA Board | Nexys A7-100T (Artix-7) |
| System Clock | 100 MHz |
| Counter terminal value | 50,000,000 (`halfCycle = 100_000_000 / 2`) |
| LED toggle period | 500 ms (toggles every half-cycle) |
| Visible blink rate | 1 Hz (full on -> off -> on) |
| Tool | Vivado |
| Language | Verilog |

---

## How It Works

A 32-bit `integer` counter increments on every rising edge of the 100 MHz clock. When the counter reaches `halfCycle - 1` (50,000,000 - 1), it resets to zero and inverts the `LED` register. The result is a 50% duty-cycle square wave on the LED at 1 Hz — essentially the simplest form of a clock divider.

---

## How to Run

1. Open `blinkLED.xpr` in Vivado.
2. Confirm `blinkLED.v` is set as the top module and the Nexys A7 XDC is included under Constraints.
3. Run **Synthesis -> Implementation -> Generate Bitstream**.
4. Connect the Nexys A7 via USB-JTAG, open the Hardware Manager, and program the device.
5. Onboard LED LD0 should blink at 1 Hz.
