# VGA Controller — Nexys A7-100T (Verilog / Vivado)

A VGA display controller implemented in Verilog and deployed on the Nexys A7-100T FPGA. The design generates industry-standard 640×480 @ 60 Hz timing signals (H-sync, V-sync, and a 25 MHz pixel clock enable derived from the 100 MHz system clock) and drives a "no signal" color-bar test pattern with 8 vertical color bands and black/white border quadrants across the full active display area.

---

## Demo

<!-- PLACEHOLDER: Capture a photo of the Nexys A7 connected via VGA cable to a monitor showing the 8-column color bar pattern. A close-up of the monitor display is ideal. -->
![Demo](./docs/demo.jpg)

*Nexys A7 driving a VGA monitor with the 8-column rainbow color bar test pattern at 640×480 @ 60 Hz*

---

## Simulation / Waveforms

<!-- PLACEHOLDER: Capture a Vivado waveform screenshot from tb_VGAcontroller. Show H_sync and V_sync toggling, Display_on going high at x=0/y=0 and low at x=640/y=480, and Pix_clk_en pulsing every 4 system clocks. -->
![Waveform](./docs/waveform.png)

---

## Architecture

```
                +-------------------------------------------+
  100 MHz Clk ->|              top_VGAdisplay                |
                |                                           |
                |   +------------------+                   |
                |   |  VGA_Controller  |                   |
                |   |  (Timing Engine) |-> H_sync -------->|-> VGA Monitor
                |   |  Div_Clk[1:0]    |-> V_sync -------->|-> VGA Monitor
                |   |  (/ 4 = 25 MHz)  |-> Display_on      |
                |   |                  |-> x_pixel[9:0]    |
                |   |                  |-> y_pixel[9:0]    |
                |   |                  |-> Pix_clk_en      |
                |   +------------------+                   |
                |           |                              |
                |           v                              |
                |   +------------------+                   |
                |   |  VGA_noSignal    |                   |
                |   |  (Pattern Gen)   |-> RGB[11:0] ----->|-> VGA Monitor
                |   |  8 color bars    |   (registered)    |
                |   +------------------+                   |
                +-------------------------------------------+
```

---

## Project Structure

| File | Description |
|------|-------------|
| `sources_1/new/top_VGAdisplay.v` | Top-level module — instantiates controller and pattern generator; registers RGB output |
| `sources_1/new/VGA_Controller.v` | Timing engine — generates H/V counters, H_sync, V_sync, Display_on, and Pix_clk_en at 25 MHz |
| `sources_1/new/VGA_noSignal.v` | Pattern generator — maps x/y pixel coordinates to 12-bit RGB color bar pattern |
| `sources_1/new/Clkgen.v` | Stand-alone 25 MHz clock generator (divide-by-4 via 2-bit counter) |
| `sources_1/new/VGA_TEST.v` | Switch-driven color test — fills the entire screen with a solid color set by 12 onboard switches (SW[11:8] = R, SW[7:4] = G, SW[3:0] = B) |
| `sim_1/new/tb_VGAcontroller.v` | VGA_Controller testbench — observes H_sync, V_sync, x/y counters |
| `sim_1/new/tb_VGA_noSignal.v` | Pattern generator testbench |
| `sim_1/new/tb_25MHz_Clk.v` | Clock generator testbench |
| `constrs_1/imports/.../Nexys-A7-100T-Master.xdc` | Pin constraints for Nexys A7-100T |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| FPGA Board | Nexys A7-100T (Artix-7) |
| System Clock | 100 MHz |
| Pixel Clock Enable | 25 MHz (100 MHz / 4, via 2-bit `Div_Clk` counter) |
| Resolution | 640x480 |
| Refresh Rate | 60 Hz |
| H total pixels | 800 (640 display + 16 front porch + 96 retrace + 48 back porch) |
| V total lines | 521 (480 display + 10 front porch + 2 retrace + 29 back porch) |
| H_sync pulse | Active low, 96 pixels wide |
| V_sync pulse | Active low, 2 lines wide |
| Color depth | 12-bit RGB (4 bits per channel) |
| Color bar width | 80 pixels per bar (640 / 8) |
| Tool | Vivado |
| Language | Verilog |

---

## How It Works

**Pixel Clock Generation.** The `VGA_Controller` module derives a 25 MHz pixel clock enable (`Pix_clk_en`) from the 100 MHz system clock using a 2-bit free-running counter (`Div_Clk`). `Pix_clk_en` is asserted for exactly one system clock every time `Div_Clk` reaches `2'b11`, giving a 25 MHz effective pixel rate without introducing a separate clock domain.

**Horizontal and Vertical Timing.** Two 10-bit counters — `H_counter` and `V_counter` — advance on each pixel clock enable. `H_counter` counts from 0 to H_MAX (640+16+96+48−1 = 799) and resets; `V_counter` increments at each `H_counter` rollover and resets at V_MAX (480+10+2+29−1 = 520). These values conform exactly to the VGA 640×480 @ 60 Hz standard.

**Sync Signal Generation.** `H_sync` goes active-low when `H_counter` falls within the 96-pixel retrace window (pixels 656–751: display + front porch through display + front porch + retrace). `V_sync` goes active-low during the 2-line retrace window (lines 490–491). `Display_on` is high only inside the 640×480 active area and gates the pattern generator — when off, the RGB output is forced to black to prevent signal bleed during blanking intervals.

**Color Bar Pattern (`VGA_noSignal`).** The pattern generator uses combinational range comparisons on `x_pixel` to divide the 640-pixel active span into eight 80-pixel-wide columns, each mapped to a distinct 12-bit RGB color: red (`12'h00F`), orange (`12'h0AF`), yellow (`12'h0FF`), green (`12'h0F0`), blue (`12'hF00`), indigo (`12'hFF0`), violet (`12'hF0F`), and pink (`12'hAAF`). The top 20 rows (y < 20) and bottom 20 rows (y >= 460) display alternating black/white quadrants as border indicators.

**Output Registration.** The top module registers the pattern generator's RGB output (`RGB_buff`) on the rising edge of the 100 MHz clock before driving the VGA output pins. This one-cycle pipeline register eliminates combinational glitches from appearing as pixel noise on the display.

---

## Testbenches

| Testbench | What It Tests | Notes |
|-----------|--------------|-------|
| `tb_VGAcontroller.v` | H/V counter rollover, H_sync and V_sync pulse positions, Display_on region | Run for at least one full frame (~16.7 ms simulation time) |
| `tb_VGA_noSignal.v` | RGB output at key pixel coordinates within each color band | Check boundary pixels at x = 80, 160, 240, 320, 400, 480, 560 |
| `tb_25MHz_Clk.v` | 25 MHz clock generator output period | — |

**To run in Vivado:**
1. Open `VGA_Controller.xpr`.
2. Right-click the desired testbench under **Simulation Sources** and select **Set as Top**.
3. Click **Run Simulation -> Run Behavioral Simulation**.
4. Zoom to a full horizontal line (800 pixel-clock periods = 32 us) to inspect H_sync timing.

---

## How to Run

1. **Open the project** — Launch Vivado and open `VGA_Controller.xpr`.
2. **Verify sources** — Confirm `top_VGAdisplay.v`, `VGA_Controller.v`, `VGA_noSignal.v`, and the Nexys A7 XDC are present.
3. **Simulate** — Set `tb_VGAcontroller` as top and run Behavioral Simulation. Verify H_sync and V_sync pulse widths and Display_on boundaries.
4. **Synthesize and implement** — Run Synthesis, then Implementation. Verify timing closure at 100 MHz.
5. **Generate bitstream** — Click **Generate Bitstream**.
6. **Program the board** — Connect the Nexys A7 via USB-JTAG. In the Hardware Manager, click **Open Target -> Auto Connect -> Program Device** and select the `.bit` file.
7. **Connect a VGA monitor** — Plug a VGA cable into the Nexys A7's VGA port. Power on — the monitor should immediately display the 8-column rainbow color bar pattern at 640x480 @ 60 Hz.
