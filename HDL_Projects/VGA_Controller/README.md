# 🖥️ VGA Controller (FPGA – Nexys A7 Board)

![Nexys A7 Board Setup](./docs/Nexys_A7_Setup.jpg)

### 🎯 Overview
This project implements a **VGA Controller** on the **Nexys A7-100T FPGA development board**, written in **Verilog HDL**.  
The system generates VGA timing signals for a 640x480 resolution display at 60Hz, outputting a "No Signal" pattern with color bars and border indicators.

Designed with modular components for timing generation and pattern display, it demonstrates video signal generation and FPGA-based graphics.

---

## ⚙️ Features
✅ Generates **640x480 VGA timing** at 60Hz  
✅ Outputs **H_sync** and **V_sync** signals  
✅ Displays "No Signal" pattern with **8 color bars** (ROYGBIV + Pink)  
✅ Includes border areas (white/black quadrants)  
✅ Pixel clock generation from 100MHz input  
✅ Active display area control  

---
## 🧰 Tools Used
- **HDL / Simulation:**	Verilog
- **Synthesis / Implementation:** Vivado 2023.x
- **Hardware:**	Nexys A7-100T FPGA, VGA Monitor

---

## 🧩 Design Overview

### 🎮 VGA_Controller (Timing Module)
Generates VGA synchronization and pixel coordinates:

- **Horizontal Timing:** 640 display + front/back porch + retrace
- **Vertical Timing:** 480 display + front/back porch + retrace
- Pixel clock enable at 25MHz (from 100MHz divide-by-4)

**Inputs:** `Clk`, `Rst`  
**Outputs:** `Display_on`, `H_sync`, `V_sync`, `x_pixel[9:0]`, `y_pixel[9:0]`, `Pix_clk_en`

### 🎨 VGA_noSignal (Pattern Generator)
Creates the display pattern:

- **Color Bars:** Red, Orange, Yellow, Green, Blue, Indigo, Violet, Pink
- **Borders:** Upper-left white, upper-right black, lower-left black, lower-right white
- **Background:** Black outside display area

**Inputs:** `Display_on`, `x_pixel[9:0]`, `y_pixel[9:0]`  
**Outputs:** `RGB[11:0]` (4-bit per color channel)

### ⏱️ Clkgen (Clock Generator)
Provides additional clock signals if needed (not directly used in top).

### 🖼️ top_VGAdisplay (Top Module)
Integrates controller and pattern generator, buffers RGB output.

---

## 🔧 Setup and Usage
1. **Synthesize and Program:** Open in Vivado, synthesize, and program Nexys A7 board.
2. **Connect VGA Monitor:** Use VGA cable from board to monitor.
3. **Power On:** Board generates VGA signal; monitor should display color bars pattern.
4. **Reset:** Press board reset to restart timing.

---

## 📊 Block Diagram
```
FPGA (100MHz) -> VGA_Controller -> H_sync, V_sync, x/y coords
                        |
                        v
                 VGA_noSignal -> RGB[11:0] -> VGA Monitor
```

---

## 🐛 Debugging Tips
- **No Display:** Check VGA pin constraints in `.xdc` file and cable connection.
- **Wrong Resolution:** Verify timing parameters match monitor specs.
- **Color Issues:** Ensure RGB pins are correctly mapped (12-bit color).
- **Flicker:** Check pixel clock frequency (should be 25MHz for 640x480).

---
**Note:** Designed for standard VGA monitors. Ensure correct pin mappings for Nexys A7 VGA port in constraints file.