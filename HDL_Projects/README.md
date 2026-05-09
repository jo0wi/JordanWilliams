# HDL Projects

Verilog FPGA designs targeting the Nexys A7-100T (Artix-7) and Basys3 boards, plus simulation-only designs verified with Icarus Verilog. All projects are written and verified in Vivado unless otherwise noted.

---

## Top-Level Designs

| Project | Board | Summary |
|---|---|---|
| [UART Transceiver](./uart%20transceiver/) | Nexys A7-100T | Full-duplex 115200-baud UART with hex display + PuTTY echo loop. |
| [VGA Controller](./VGA_Controller/) | Nexys A7-100T | 640×480 @ 60 Hz timing engine with 8-column color-bar test pattern. |
| [Verilog Single-Cycle CPU](./Verilog_SCC/Final/) | Icarus Verilog | 32-bit single-cycle CPU with ARM-Educore-style ISA + self-checking testbench. |
| [UART ESP32 Bridge](./UART_Interface_ESP_32/) | Nexys A7-100T | UART loopback retargeted to ESP32 PMOD pins. |

## Building Blocks

| Project | Board | Summary |
|---|---|---|
| [Blink LED](./blinkLED/) | Nexys A7-100T | Clock-divider intro project — LED toggles at 1 Hz. |
| [Debounced Toggle Button](./debounce_toggle_btn/) | Nexys A7-100T | 1 ms button debouncer + edge-triggered LED toggle. |
| [Seven-Segment Counter](./seven_segment_cntr/) | Nexys A7-100T | Synchronous 4-bit hex → 7-segment encoder (counter/timer building block). |

## Course Labs

| Project | Board | Summary |
|---|---|---|
| [Digital Design Labs](./Digital_Design_Labs/) | Basys3 | ELEE 4280 Digital Systems Design lab projects (gates, FSMs, decoders, capstone reaction timer). |

---

## Shared Constraints

`Nexys-A7-100T-Master.xdc` is the master pin-mapping file shared by every Nexys A7 project here. Each project's `constrs_1/` folder imports this same file so pin assignments stay consistent across designs.

---

## Tooling

| Tool | Purpose |
|---|---|
| Xilinx Vivado | Synthesis, implementation, simulation, bitstream, hardware programming |
| Icarus Verilog | Lightweight simulation (used for the SCC project and CI-style testbenches) |
| GTKWave | Waveform viewing for Icarus output (`dump.vcd`) |
