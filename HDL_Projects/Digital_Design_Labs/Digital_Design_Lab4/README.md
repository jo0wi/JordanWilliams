# Digital Design Lab 4 — Laser FSM + 8-Bit Register

**Course:** ELEE 4280 Digital Systems Design — Lab 4 · Basys3 / Vivado / Verilog

A pair of small sequential-logic exercises:

1. **`Laser_FSM`** — a button-triggered 4-tick laser pulse: pressing the button drives the `lzr` output high for four clock edges, then auto-resets and waits for the next press.
2. **`Register_8bit`** — an 8-bit parallel-load register built from a 1-bit register cell (`Register_1bit`), in turn built from a `Flip_Flop` primitive — a hierarchy exercise.

A `Timer_FSM` module is stubbed out for a follow-on lab.

---

## Files

| File | Description |
|------|-------------|
| `sources_1/new/Laser_FSM.v` | Laser pulse FSM (4-cycle output on press) |
| `sources_1/new/Flip_Flop.v` | D flip-flop primitive |
| `sources_1/new/Register_1bit.v` | 1-bit register cell built around `Flip_Flop` |
| `sources_1/new/Register_8bit.v` | 8-bit register built from eight `Register_1bit` instances |
| `sources_1/new/Timer_FSM.v` | Reserved stub |
| `sim_1/new/Laser_FSM_tb.v` | Laser FSM testbench |
| `sim_1/new/register_8ibt_tb.v` | 8-bit register testbench |

---

## How to Run

1. Open `Digital_Design_Lab4.xpr` in Vivado.
2. Set the desired testbench as simulation top and run **Behavioral Simulation**.
3. For hardware bring-up, set `Laser_FSM` (or a top wrapper) as synthesis top, generate bitstream, and program the Basys3.
