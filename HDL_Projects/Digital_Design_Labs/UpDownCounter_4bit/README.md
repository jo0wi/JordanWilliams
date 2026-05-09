# 4-Bit Up/Down Counter — Basys3 (Verilog / Vivado)

A 4-bit synchronous up/down counter that wraps at the boundaries (15 -> 0 counting up, 0 -> 15 counting down) and a top-level wrapper that pairs it with a 1 Hz clock divider and a hex seven-segment decoder, so the live count value is displayed on a Basys3 onboard digit.

---

## Project Structure

| File | Description |
|------|-------------|
| `sources_1/new/UpDownCounter_4bit.v` | Counter core — 4-bit register with wrap-around, clocked behavior, synchronous reset |
| `sources_1/new/UD_Counter_Top.v` | Top — instantiates `ClkDiv`, `UpDownCounter_4bit`, and `Decoder7Seg`; routes count value to a 7-segment digit |
| `sources_1/imports/new/ClkDiv.v` | *(imported)* Configurable clock divider; `DIV_CLK = 50_000_000` -> 1 Hz visible count |
| `sources_1/imports/new/Binary_Ssd.v` | *(imported)* Combinational hex -> 7-segment decoder (`Decoder7Seg`) |
| `sim_1/new/UpDownCounter_tb.v` | Counter-only testbench |
| `sim_1/new/UD_CounterTop_tb.v` | Full top-level testbench (counter + clock div + decoder) |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| FPGA Board | Basys3 (Artix-7) |
| Counter width | 4 bits (range 0-15) |
| Wrap behavior | Up: 15 -> 0; Down: 0 -> 15 |
| Visible count rate | 1 Hz (configurable via `DIV_CLK` parameter on `UD_Counter_Top`) |
| Inputs | `Clk` (100 MHz), `Rst`, `Enable`, `UpDown`, `DivRst` |
| Outputs | `A`-`G` segments, `SegSel`, `ClkOut` (probe) |
| Tool | Vivado |
| Language | Verilog |

---

## Control Signals

| Signal | Behavior |
|--------|----------|
| `Rst = 1` | Force `Cnt` to 0 (synchronous) |
| `Enable = 0` | Hold current count |
| `Enable = 1`, `UpDown = 1` | Count up (wraps 15 -> 0) |
| `Enable = 1`, `UpDown = 0` | Count down (wraps 0 -> 15) |
| `DivRst = 1` | Reset clock-divider counter (resyncs the visible 1 Hz tick) |

---

## How to Run

1. Open `UpDownCounter_4bit.xpr` in Vivado.
2. Verify `UD_Counter_Top` is the synthesis top and the Basys3 XDC is included.
3. Run **Synthesis -> Implementation -> Generate Bitstream** and program the Basys3.
4. Set switches to drive `Enable` and `UpDown`; the seven-segment display should advance once per second between `0` and `F`.

For faster simulation set `DIV_CLK` to a smaller value (e.g. `DIV_CLK = 10` in the testbench) so several count steps fit in a reasonable simulation window.
