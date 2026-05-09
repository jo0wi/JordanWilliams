# Seven-Segment Hex Decoder — Basys3 (Verilog / Vivado)

A purely combinational 4-bit hexadecimal to seven-segment decoder (`Decoder7Seg`). Maps each of the 16 hex digits (`0`-`F`) to the active-high segment pattern for a single common-cathode display digit. This module is reused as a building block by the [Up/Down Counter](../UpDownCounter_4bit/) and other lab projects in this directory.

---

## Project Structure

| File | Description |
|------|-------------|
| `sources_1/new/Binary_Ssd.v` | `Decoder7Seg` — combinational `case`-statement lookup, `{A,B,C,D,E,F,G}` outputs, `SegSel = 0` (single-digit enable) |
| `sim_1/new/BtoSSD_tb.v` | Sweeps all 16 input combinations and inspects the segment outputs |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Inputs | `In3, In2, In1, In0` — single-bit bus packed as `N[3:0]` |
| Outputs | `A`-`G` (active-high), `SegSel` (digit-enable, tied low) |
| Style | Combinational `always @*` with case lookup |
| Display polarity | Active-high (use `~` for active-low common-anode boards) |
| Tool | Vivado |
| Language | Verilog |

---

## Segment Map

```
   --A--
  |     |
  F     B
  |     |
   --G--
  |     |
  E     C
  |     |
   --D--
```

| Hex | Segments lit | `{A B C D E F G}` |
|-----|--------------|--------------------|
| 0 | A B C D E F | `1111110` |
| 1 | B C | `0110000` |
| 2 | A B D E G | `1101101` |
| 3 | A B C D G | `1111001` |
| 4 | B C F G | `0110011` |
| 5 | A C D F G | `1011011` |
| 6 | A C D E F G | `1011111` |
| 7 | A B C | `1110000` |
| 8 | all | `1111111` |
| 9 | A B C D F G | `1111011` |
| A | A B C E F G | `1110111` |
| b | C D E F G | `0011111` |
| C | A D E F | `1001110` |
| d | B C D E G | `0111101` |
| E | A D E F G | `1001111` |
| F | A E F G | `1000111` |

---

## Usage

```verilog
Decoder7Seg ssd (
    .In3(value[3]), .In2(value[2]), .In1(value[1]), .In0(value[0]),
    .A(segA), .B(segB), .C(segC),
    .D(segD), .E(segE), .F(segF), .G(segG),
    .SegSel(digit_enable)
);
```

For a Basys3 (active-low common-anode) display, invert at the top level:

```verilog
assign seg_n = ~{segA, segB, segC, segD, segE, segF, segG};
```

---

## How to Run

1. Open `Seven_Segment_Display.xpr` in Vivado.
2. Run `BtoSSD_tb` as the simulation top and confirm each segment vector matches the table above.
