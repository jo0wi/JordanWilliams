# Laser Distance Measurer (HLSM) — Basys3 (Verilog / Vivado)

A High-Level State Machine (HLSM) that models a time-of-flight laser rangefinder. On a button press the FSM pulses a laser high for one cycle, then counts clock edges until a return-pulse sensor input asserts. The cycle count is divided by 2 (out-and-back path) and held in a 16-bit display register.

> Folder name preserved with its trailing space (`Laser_Distance _Measurer`) to keep existing Vivado project paths intact.

---

## Files

| File | Description |
|------|-------------|
| `sources_1/new/Laser_DistanceHLSM.v` | `Laser_DistanceHLSM` — 5-state HLSM (`S_0`–`S_4`) |
| `sim_1/new/Laser_Distance_tb.v` | Behavioral testbench — drives `B`, `S`, `Rst`; checks `L` pulse and `D` value |

---

## State Machine

| State | Action |
|-------|--------|
| `S_0` | Reset: clear `Dreg`, `L = 0`. Move to `S_1`. |
| `S_1` | Wait for `B = 1` (button press). |
| `S_2` | Pulse `L` high for one cycle. Move to `S_3`. |
| `S_3` | Drop `L`. Increment `Dctr` on every clock until sensor input `S = 1`, then move to `S_4`. |
| `S_4` | Compute `Dreg = Dctr / 2` (round-trip → one-way) and return to `S_0`. |

### Distance Math

With `CLK_SPEED = 300 MHz` and `C = 300 × 10⁶ m/s` (chosen so each clock period equals 1 m of round-trip travel), the one-way distance in meters is `D = Dctr / 2`. In a real implementation the clock and `C` would be calibrated to actual hardware.

---

## Specifications

| Parameter | Value |
|-----------|-------|
| FPGA Board | Basys3 (Artix-7) |
| `CLK_SPEED` | 300 MHz (modeling parameter) |
| `D` width | 16 bits |
| Inputs | `Clk`, `Rst`, `B` (button), `S` (return-pulse sensor) |
| Outputs | `L` (laser drive), `D[15:0]` (distance display) |
| Tool | Vivado |
| Language | Verilog |

---

## How to Run

1. Open `Laser_Distance _Measurer.xpr` in Vivado.
2. Run `Laser_Distance_tb` as the simulation top to verify the FSM transitions and the `Dreg = Dctr / 2` calculation.
