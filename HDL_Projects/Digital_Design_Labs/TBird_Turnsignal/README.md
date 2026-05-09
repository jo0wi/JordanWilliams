# Thunderbird Turn Signal — Basys3 (Verilog / Vivado)

A finite-state-machine implementation of the classic 1965 Ford Thunderbird sequential turn signal: each press of `Left` or `Right` walks a three-LED chain outward (`A -> A+B -> A+B+C`) before returning to the off state. Implemented as a one-process Mealy/Moore hybrid FSM clocked at 1 Hz on the Basys3.

---

## Project Structure

| File | Description |
|------|-------------|
| `sources_1/new/TurnSignal_FSM.v` | `ThunderbirdFSM` — 7-state FSM (`S_Off`, `S_L1-L3`, `S_R1-R3`) |
| `sources_1/new/ClkDiv.v` | `ClkDiv` — divide-by-50 M counter; produces 1 Hz tick from the 100 MHz Basys3 clock |
| `sources_1/new/TB_FSM_1Hz_Top.v` | Top — wires `ClkDiv` into `ThunderbirdFSM`, mapping switches/LEDs to the Basys3 |
| `sim_1/new/TBird_Turrnsignal_tb.v` | Behavioral testbench — exercises Left, Right, and reset sequences |
| `sim_1/new/ClkDiv_tb.v` | Standalone clock-divider testbench |

---

## State Diagram

```
                Left & !Right
        S_Off ---------------> S_L1 --> S_L2 --> S_L3 --+
          ^                                              |
          | <--------------------------------------------+
          |
          | Right & !Left
          +-----------------> S_R1 --> S_R2 --> S_R3 --+
                                                         |
                              <--------------------------+
```

| State | LEDs Lit |
|-------|----------|
| `S_Off` | none |
| `S_L1` | LA |
| `S_L2` | LA, LB |
| `S_L3` | LA, LB, LC |
| `S_R1` | RA |
| `S_R2` | RA, RB |
| `S_R3` | RA, RB, RC |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| FPGA Board | Basys3 (Artix-7) |
| System Clock | 100 MHz |
| FSM Tick | 1 Hz (`HalfCLK = 50_000_000`) |
| Inputs | `Left`, `Right`, `Rst` (synchronous) |
| Outputs | `LA, LB, LC` (left chain), `RA, RB, RC` (right chain) |
| Tool | Vivado |
| Language | Verilog |

---

## How It Works

The clock divider produces a 1 Hz pulse from the 100 MHz Basys3 oscillator using a free-running counter. The FSM clocks on this divided edge. From `S_Off`, asserting only `Left` advances the FSM through `S_L1 -> S_L2 -> S_L3` over three seconds, illuminating one additional LED on each step before returning to `S_Off`. `Right` triggers the mirrored sequence. Asserting both inputs simultaneously is treated as no command (FSM stays in `S_Off`). The reset is synchronous and forces the state register back to `S_Off` immediately.

---

## How to Run

1. Open `TBird_Turnsignal.xpr` in Vivado.
2. Verify `TB_FSM_1Hz_Top` is the synthesis top and the Basys3 XDC (in the parent `Digital_Design_Labs/` folder) is included.
3. Run **Synthesis -> Implementation -> Generate Bitstream** and program the Basys3.
4. Map two switches to `Left` / `Right` and one button to `Rst`. Six LEDs (or external 3+3 LEDs wired to PMOD pins) display the sequence.
