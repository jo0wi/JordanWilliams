# Jordan Williams — Hardware Engineering Portfolio

**Electrical Engineering Student | FPGA | PCB Design | Embedded Systems**
B.S. Electrical Engineering + Certificate in E-Mobility — University of Georgia — Graduating July 2026

[LinkedIn](https://www.linkedin.com/in/jordan-williams-029b55268) | jordan1296w@gmail.com | (770) 241-4475

---

## About Me

I am a final-year Electrical Engineering student at the University of Georgia specializing in FPGA digital design, PCB layout, and embedded systems. I have hands-on experience designing hardware from RTL to bitstream in Vivado, implementing closed-loop control systems on embedded platforms, and contributing to flight hardware for a 6U CubeSat mission at the UGA Small Satellite Research Laboratory. For my senior capstone, I designed an 8-module, 660V, ~1,000-cell high-voltage battery accumulator for UGA's inaugural FSAE Electric Vehicle.

I am actively seeking full-time hardware, digital design, or embedded systems engineering roles starting Summer/Fall 2026.

---

## Skills

| Category | Tools / Technologies |
|---|---|
| **HDL** | Verilog |
| **FPGA** | Nexys A7-100T (Artix-7), Basys3, Xilinx Vivado |
| **PCB Design** | Altium Designer (Schematic Capture, Layout, BOM Generation), LTSpice |
| **Embedded** | C/C++, MicroPython, Arduino, ESP32, Raspberry Pi Pico (RP2040), Raspberry Pi |
| **Protocols** | UART, I2C, SPI, USB, BLE / Bluetooth, WiFi / IoT |
| **Languages** | Verilog, C/C++, Python, MATLAB / Simulink |
| **Simulation & EDA** | Xilinx Vivado, ModelSim, GTKWave, Icarus Verilog |
| **Lab Equipment** | Oscilloscopes, DMMs, Function Generators, Power Supplies, Soldering, PCB Assembly |
| **Other** | Git / GitHub, PLC Programming |

---

## Featured Projects

| Project | Platform | Description |
|---|---|---|
| [UART Transceiver](./HDL_Projects/uart%20transceiver/) | Nexys A7-100T | Full-duplex UART at 115200 baud — echoes keystrokes from PuTTY to terminal and displays received byte in hex on seven-segment display |
| [Single-Cycle CPU](./HDL_Projects/Verilog_SCC/Final/) | Icarus Verilog / Vivado | 32-bit single-cycle processor with ARM-Educore ISA — full datapath (IF/ID/EXE/MEM/WB), 16 registers, multiply microcode, self-checking testbench |
| [VGA Controller](./HDL_Projects/VGA_Controller/) | Nexys A7-100T | 640×480 @ 60 Hz VGA timing engine with 8-column rainbow color bar test pattern |
| [Magnetic Levitator](./Magnetic_Levitator/) | Raspberry Pi Pico (RP2040) | Closed-loop levitation system with cascaded PD + discrete lead compensator suspending a neodymium magnet at a 3 mm gap using Hall effect feedback and 10 kHz PWM-controlled solenoid; plant modeled in MATLAB |
| [ESP32 Environmental Monitor](./Embedded-Programing_Projects/CacheEmulator/Air_Quality_Sensor_Project/) | ESP32 | Multi-sensor IoT monitor (BMP280, DHT11, thermistor, dust sensor) with I2C LCD and ThingSpeak cloud push every 5 minutes over WiFi |

---

## Experience

### UGA Small Satellite Research Laboratory (SSRL) — Feb 2024–Present
**Electrical Hardware Team Member** | MOCI 6U CubeSat Mission | Athens, GA

- Designing, reviewing, and implementing electronics for the Multi-view Onboard Computational Imager (MOCI) 6U CubeSat mission
- Directly designed and assembled a flight-candidate PCB for mission-critical subsystems
- Developing the satellite wiring harness and authored a Safe-to-Mate assembly procedure based on NASA standards
- Repaired tracking dish motors and drive electronics to restore ground station operations
- Created procedure documentation to standardize hardware workflows and support team onboarding

### UGA Formula SAE Electric Vehicle — Fall 2025–Spring 2026
**High-Voltage Accumulator Design** | Electrical Engineering Capstone

- Designed an 8-module, 660V HV battery accumulator (~1,000 18650 Li-ion cells, 12.33 kWh) for UGA's inaugural FSAE EV
- Performed cell configuration analysis and power draw calculations to meet powertrain energy and current requirements
- Conducted fusible link testing between cells and bus bar to validate overcurrent protection under simulated fault conditions

---

## Education

**University of Georgia** — Athens, GA
- B.S. Electrical Engineering — Expected July 2026
- Certificate in E-Mobility — Expected July 2026

**Relevant Coursework:** Digital Systems Design, Embedded Systems, Digital Signal Processing, Signals & Systems, Electronics I & II, Microelectronics, Control Systems
