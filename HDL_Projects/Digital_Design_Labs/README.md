# 🕒 Reaction Timer (FPGA – Basys3 Board)

![Basys3 Board Setup](./docs/Basys3_Setup.jpg)

### 🎯 Overview
This project implements a **Reaction Timer** on the **Basys3 FPGA development board**, written in **Verilog HDL** and displayed on a **Pmod CLP 16×2 LCD**.  
The system measures a user’s reaction time between the LED illumination and a button press, then displays the result on the LCD.

Designed as a **High-Level State Machine (HLSM)** using the **one-procedure behavioral method**, the design demonstrates digital logic control, timing, and hardware integration.

---

## ⚙️ Features
✅ Displays startup message “Reaction Timer” on reset  
✅ Waits a **random delay (1–3 seconds)** before LEDs turn on  
✅ Measures user reaction time in milliseconds  
✅ Displays result on LCD (`"0.345s"`)  
✅ Detects and reports **cheating** (early button press)  
✅ Detects **slow responses** (> 0.5 s)  
✅ Debounce protection for button input  
✅ LCD communication via **LCDUpdate/LCDAck handshaking**

---

## 🧩 Design Overview

### 🧠 ReactionTimer (Main FSM)
Implements all control logic and states:

| State | Description |
|-------|--------------|
| **Reset** | Displays intro message “Reaction Timer” |
| **Wait** | Displays “Wait for LEDs…” and random delay |
| **LED On** | Turns on LEDs and starts timing |
| **Measure** | Records reaction time or flags cheat/slow |
| **Display** | Shows message on LCD via handshake |

**Inputs:** `ClkMS`, `Rst`, `Start`, `LCDAck`, `RandomValue`  
**Outputs:** `LED[7:0]`, `ReactionTime[9:0]`, `Cheat`, `Slow`, `Wait`, `LCDUpdate`

![State Diagram](./docs/StateDiagram.png)

---

### ⏱ Clock Divider (`ClkDiv`)
Generates a **1 kHz clock** (`ClkMS`) from the Basys3’s 50 MHz input clock.  
Used for timing in milliseconds.  
Verified in simulation using a testbench waveform.

**Expected Period:** 1 ms  
![Clock Divider Waveform](./docs/ClkDiv_Waveform.png)

---

### 🎲 Random Delay Generator (`RandomGen`)
Produces a pseudo-random delay between **1 – 3 seconds** to vary the LED trigger time.  
Implemented using a shift register and counter to simulate randomness (no `$random`).  

**Verification:** Random values observed in waveform traces.  
![Random Generator Waveform](./docs/RandomGen_Waveform.png)

---

### 🖥 LCD Display Interface
Interacts with the **Pmod CLP LCD** using handshake signals:
- LCDUpdate ↑ → ReactionTimer requests display
- LCDAck ↑ → LCD acknowledges update
- LCDUpdate ↓ → ReactionTimer ends handshake

**Messages Displayed:**
- `"Reaction Timer"` (startup)
- `"Wait for LEDs..."`
- `"No Cheating!"`
- `"Too Slow!"`
- `"0.xxxs"` (measured time)

![LCD Display Example](./docs/LCD_Display.jpg)

---

## 🔩 System Block Diagram
```text
 ┌────────────────────────────┐
 │           Top.v            │
 │  ┌──────────────────────┐  │
 │  │     ReactionTimer    │◄─┐ Start Button
 │  ├──────────────────────┤  │
 │  │  ClkDiv | RandomGen  │  │
 │  ├──────────────────────┤  │
 │  │     LCDDisplay       │──► LCD (Pmod CLP)
 │  └──────────────────────┘  │
 └────────────────────────────┘
             │
             └──► LEDs (8-bit Output)
