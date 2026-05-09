# Verilog Single-Cycle CPU

A 32-bit single-cycle processor with an ARM-Educore-style ISA, implemented in Verilog and verified in Icarus Verilog. The current build is in [`Final/`](./Final/) — a complete IF / ID / EXE / MEM / WB datapath with a multiply microcode engine, 16 general-purpose registers, and a self-checking testbench that compares the post-execution memory dump against an emulator-generated reference CSV.

> Course context: ELEE 4280 / Digital Systems Design — group capstone (Group 5, Fall 2025). Course-issued single-cycle overview: [`SingleCycleOverview F2025.7.pdf`](./SingleCycleOverview%20F2025.7.pdf).

---

## Contents

| Path | Description |
|---|---|
| [`Final/`](./Final/) | Final RTL, microcode ROM, testbenches, example assembly programs, and design documentation. **Start here.** |
| `SingleCycleOverview F2025.7.pdf` | Course handout — block diagram, ISA encoding, expected behavior. |
