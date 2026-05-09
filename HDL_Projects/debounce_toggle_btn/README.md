# Debounced Toggle Button — Nexys A7-100T (Verilog / Vivado)

A button-debouncer paired with an edge-triggered LED toggle. The debouncer rejects mechanical contact bounce by requiring the input to remain stable for 1 ms before the filtered output changes; the toggle module then flips the LED on each clean falling edge of the filtered signal.

---

## Project Structure

| File | Description |
|------|-------------|
| `sources_1/new/debounce_btn.v` | `debounce` module — 27-bit counter that rejects bounces shorter than 1 ms at 100 MHz |
| `sources_1/new/toggle_btn.v` | `toggle_btn` top — instantiates the debouncer, captures previous state, toggles the LED on the falling edge of the filtered button |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| FPGA Board | Nexys A7-100T (Artix-7) |
| System Clock | 100 MHz |
| Debounce window | 1 ms (`cycle_limit = 1_000_000`) |
| Counter width | 27 bits |
| Active edge for toggle | Falling edge of debounced signal |
| Tool | Vivado |
| Language | Verilog |

---

## How It Works

**Debouncer.** Each clock cycle the module compares the raw input `c_btn` to the latched state `btn_state`. If they disagree it increments a 27-bit counter; the counter resets to 0 the moment the input matches the latched state again. Only when the inputs disagree continuously for `cycle_limit` cycles (1 ms) does `btn_state` adopt the new value. This rejects narrow bounces while still allowing legitimate transitions through with a fixed 1 ms latency.

**Toggle.** The top module registers the debouncer output and watches for a `1 -> 0` transition (button release). On detection, it inverts the LED register. Using a single edge prevents multiple toggles from a single press.

---

## How to Run

1. Open `debounce_toggle_btn.xpr` in Vivado.
2. Verify `toggle_btn.v` is the top module and the Nexys A7 XDC is included.
3. Run **Synthesis -> Implementation -> Generate Bitstream** and program the board.
4. Press any onboard pushbutton — the assigned LED should toggle exactly once per press, with no flicker.
