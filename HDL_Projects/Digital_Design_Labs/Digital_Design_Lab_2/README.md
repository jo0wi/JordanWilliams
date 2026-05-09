# Digital Design Lab 2 — Belt Warning + 2-to-4 Decoder

**Course:** ELEE 4280 Digital Systems Design — Lab 2 · Basys3 / Vivado / Verilog

Two combinational-logic exercises that reinforce truth-table-driven design:

1. **`Belt_Warn`** — seat-belt warning logic. The warning light `W` turns on if the key is in the ignition (`K = 1`), there's a person in the seat (`P = 1`), and the seat belt is **not** buckled (`S = 0`).
2. **`Decoder2to4`** — a one-hot 2-to-4 decoder driving `Q0`-`Q3` directly from the two-bit input `{A, B}` via a `case` statement.

A `BeltWarn_Circuit` and `Decoder_circuit` variant are included as alternate gate-level implementations for comparison against the behavioral versions.

---

## Files

| File | Description |
|------|-------------|
| `sources_1/new/Belt_Warn.v` | Behavioral seat-belt-warning logic (`W = K & P & ~S`) |
| `sources_1/new/BeltWarn_Circuit.v` | Gate-level seat-belt-warning variant |
| `sources_1/new/Decoder2to4.v` | Behavioral 2-to-4 decoder (`case` statement) |
| `sources_1/new/Decoder_circuit.v` | Gate-level decoder variant |
| `sources_1/new/Lab2part_2.v` | Top-level wrapper combining the two designs |
| `sim_1/new/Belt_Warn_tb.v` | Belt-warning testbench |
| `sim_1/new/Decoder2to4_tb.v` | Decoder testbench |
| `sim_1/new/Lab2part_2_tb.v` | Top-level testbench |

---

## Truth Tables

### `Belt_Warn`

| K | P | S | W |
|---|---|---|---|
| 0 | x | x | 0 |
| 1 | 0 | x | 0 |
| 1 | 1 | 0 | **1** |
| 1 | 1 | 1 | 0 |

### `Decoder2to4`

| A | B | Q3 | Q2 | Q1 | Q0 |
|---|---|----|----|----|----|
| 0 | 0 | 0 | 0 | 0 | 1 |
| 0 | 1 | 0 | 0 | 1 | 0 |
| 1 | 0 | 0 | 1 | 0 | 0 |
| 1 | 1 | 1 | 0 | 0 | 0 |

---

## How to Run

1. Open `Digital_Design_Lab_2.xpr` in Vivado.
2. Pick a testbench as simulation top and run **Behavioral Simulation** to walk every input combination.
3. For hardware bring-up, target the Basys3 with switches as inputs and LEDs as outputs.
