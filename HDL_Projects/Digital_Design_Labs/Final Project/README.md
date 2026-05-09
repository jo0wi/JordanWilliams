# Reaction Timer — Basys3 (Verilog / Vivado)

A reaction-timer game implemented as a High-Level State Machine (HLSM) on the Basys3 FPGA. After a random 1–3 second delay the LEDs light; the user reacts by pressing the start button, and the response time is displayed in seconds on a Pmod CLP 16×2 LCD. The system also detects cheating (button pressed before LEDs light) and slow responses (> 0.5 s).

> Final project for ELEE 4280 Digital Systems Design. Full report: [`DigitalDesignFinalProject.pdf`](./DigitalDesignFinalProject.pdf).

<!-- PLACEHOLDER: photo of Basys3 + Pmod CLP LCD with the timer running. Drop image into ./docs/ and reference here. -->

---

## Features

- Startup splash "Reaction Timer" displayed on reset
- Random delay (1–3 s) before LEDs light
- Reaction time measured in milliseconds, displayed as `0.345s`
- Cheat detection (button press during the random wait)
- Slow-response flag (> 500 ms)
- Debounced button input
- Pmod CLP LCD driven via `LCDUpdate` / `LCDAck` request-acknowledge handshake

---

## Tools Used

| Layer | Tool |
|---|---|
| HDL / Simulation | Verilog |
| Synthesis / Implementation | Vivado 2023.x |
| Hardware | Basys3 FPGA, Pmod CLP 16×2 LCD |

---

## Design Overview

### `ReactionTimer` — main FSM

| State | Description |
|-------|-------------|
| **Reset** | Show splash "Reaction Timer" |
| **Wait** | Show "Wait for LEDs..." and start the random delay |
| **LED On** | Turn on LEDs and begin millisecond timing |
| **Measure** | Stop the timer on button press; flag cheat / slow if applicable |
| **Display** | Format the result and request an LCD update via handshake |

**Inputs:** `ClkMS`, `Rst`, `Start`, `LCDAck`, `RandomValue`
**Outputs:** `LED[7:0]`, `ReactionTime[9:0]`, `Cheat`, `Slow`, `Wait`, `LCDUpdate`

### `ClkDiv`

Generates a 1 kHz `ClkMS` from the Basys3 50 MHz input clock — the time base for millisecond-resolution measurement. Verified by waveform inspection in a behavioral testbench.

### `RandomGen`

Produces a pseudo-random delay between 1 s and 3 s using a shift register and counter (no `$random`, since the design must be synthesizable).

### LCD Display Interface

Communicates with the Pmod CLP 16×2 LCD over a request-acknowledge handshake:

- `LCDUpdate ↑` — `ReactionTimer` requests a display update
- `LCDAck ↑` — LCD acknowledges
- `LCDUpdate ↓` — `ReactionTimer` ends the handshake

**Messages:**
- `Reaction Timer` (startup)
- `Wait for LEDs...`
- `No Cheating!`
- `Too Slow!`
- `0.xxxs` (measured time)
