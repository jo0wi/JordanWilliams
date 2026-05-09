# Digital Design Labs — ELEE 4280

Verilog lab projects from ELEE 4280 Digital Systems Design at the University of Georgia. All targets the **Basys3** (Artix-7) board and shares the master pin-constraint file `Basys-3-Master.xdc`.

---

## Lab Index

| Lab | Project | Topic |
|---|---|---|
| 2 | [Belt Warning + 2-to-4 Decoder](./Digital_Design_Lab_2/) | Combinational logic, truth tables, behavioral vs. gate-level styles |
| — | [Primitive Gates](./primative_gates/) | Two-input AND / OR gates with self-checking testbenches |
| — | [Seven-Segment Hex Decoder](./Seven_Segment_Display/) | Combinational 4-bit hex → 7-segment LUT (reused by other labs) |
| — | [Up/Down Counter (4-bit)](./UpDownCounter_4bit/) | Synchronous counter with wrap-around, clock divider, 7-seg display |
| — | [Thunderbird Turn Signal](./TBird_Turnsignal/) | 7-state FSM driving sequential left/right turn-signal animation |
| 4 | [Laser FSM + 8-bit Register](./Digital_Design_Lab4/) | FSM-driven laser pulse + hierarchical register from D-flip-flop primitives |
| — | [Laser Distance Measurer (HLSM)](./Laser_Distance%20_Measurer/) | High-Level State Machine modeling time-of-flight rangefinding |
| Final | [Reaction Timer](./Final%20Project/) | HLSM reaction-timer with random delay, ms timing, LCD over handshake |

---

## Shared Files

- `Basys-3-Master.xdc` — pin-constraint file used by every project in this folder.

---

## How to Open Any Lab

1. `cd` into the lab folder.
2. Open the `.xpr` file in Vivado.
3. The Basys3 master XDC and `sources_1` / `sim_1` directories are pre-wired into each project.
