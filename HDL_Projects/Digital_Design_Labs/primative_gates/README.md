# Primitive Gates — Verilog / Vivado

Hand-written Verilog implementations of two-input AND and OR gates with self-checking testbenches. The first lab in the ELEE 4280 Digital Systems Design sequence — establishes the project / simulation / synthesis flow in Vivado before moving on to multi-module designs.

> **Folder name note:** `primative_gates` is a misspelling of *primitive*; the directory name is preserved to keep existing Vivado project paths intact.

---

## Project Structure

| File | Description |
|------|-------------|
| `sources_1/new/AND2_Gate.v` | `AND2_Gate(A, B, F)` — `F = A & B` in a sensitivity-list always block |
| `sources_1/new/OR2_Gate.v` | `OR2_Gate(A, B, F)` — `F = A \| B` in a sensitivity-list always block |
| `sources_1/new/AND2gate_tb.v` | Walk-through testbench for the AND gate (all four input combinations) |
| `sources_1/new/OR2_Gate_tb.v` | Walk-through testbench for the OR gate |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Inputs | `A`, `B` — single-bit |
| Output | `F` — single-bit, declared `reg` (driven inside an always block) |
| Style | Behavioral (combinational always block) |
| Tool | Vivado |
| Language | Verilog |

---

## Truth Tables

| A | B | AND `F` | OR `F` |
|---|---|---------|--------|
| 0 | 0 | 0 | 0 |
| 0 | 1 | 0 | 1 |
| 1 | 0 | 0 | 1 |
| 1 | 1 | 1 | 1 |

---

## How to Run

1. Open `primative_gates.xpr` in Vivado.
2. Set either testbench (`AND2gate_tb` or `OR2_Gate_tb`) as simulation top.
3. Run **Run Simulation -> Run Behavioral Simulation**.
4. Confirm `F` matches the expected truth table at each stimulus step.
