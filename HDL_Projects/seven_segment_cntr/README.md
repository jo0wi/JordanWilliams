# Seven-Segment Hex Encoder — Verilog / Vivado

A clocked 4-bit binary to seven-segment encoder intended as a building block for hex displays in counters, timers, and clock projects. The module latches a 4-bit value on the rising clock edge and drives the seven segment outputs (A-G) for the hex digits `0`-`F`.

> **Status:** Encoder is functional. `clock_7sd.v` is a stub — reserved for an upcoming top-level clock/counter module that will instantiate this encoder.

---

## Project Structure

| File | Description |
|------|-------------|
| `sources_1/new/binary_to_7sd.v` | `binary_to_7sd` — synchronous 4-bit -> 7-segment encoder (active-high segments) |
| `sources_1/new/clock_7sd.v` | Empty stub for a future clock/counter top module |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Encoding | 4-bit binary -> 7-bit segment vector (`A`-`G`) |
| Polarity | Active-high (segments illuminate on logic 1) |
| Sampling | Synchronous on `posedge clk` |
| Supported digits | `0`-`F` (full hexadecimal range) |
| Tool | Vivado |
| Language | Verilog |

---

## How It Works

A `case` statement maps each 4-bit input to a 7-bit segment pattern stored in `hex_encoding`. Each pattern is laid out as `{A, B, C, D, E, F, G}` with a `1` indicating the corresponding segment is lit. Latching the lookup output on a clock edge keeps the timing predictable when the encoder is fed from a counter and prevents combinational glitches from rippling onto the display.

### Sample mappings

| Input (hex) | `hex_encoding` (binary) | Segments lit |
|---|---|---|
| `0` | `1111110` | A B C D E F |
| `1` | `0110000` | B C |
| `7` | `1110000` | A B C |
| `A` | `1110111` | A B C E F G |
| `F` | `1000111` | A E F G |

---

## Usage

```verilog
binary_to_7sd display_driver (
    .clk(system_clock),
    .bin_num(counter_value),
    .A(segA), .B(segB), .C(segC),
    .D(segD), .E(segE), .F(segF), .G(segG)
);
```

To drive a Nexys A7 (active-low common-anode) display, invert the segment outputs at the top level: `assign seg_n = ~{A, B, C, D, E, F, G};`.
