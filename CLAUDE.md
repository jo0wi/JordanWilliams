# Claude Code Instructions — Jordan Williams Portfolio Restructure

## Who I Am
I'm Jordan Williams, a final-year Electrical Engineering student at the University of Georgia (graduating July 2026). I'm building a hardware engineering portfolio targeting FPGA, PCB, and embedded systems roles. This repo currently contains all my projects in one monorepo. I need help splitting it into individual repos and writing professional READMEs for each one.

---

## Your Goal
Help me restructure this monorepo into individual, recruiter-ready GitHub repositories. Each project should be its own standalone repo with a polished README.

---

## Step 1 — Understand the Current Structure
First, explore the repo and list all files and folders. Pay attention to:
- `HDL_Projects/` — contains all Verilog/FPGA projects
- `Embedded-Programing_Projects/` — contains C++ and Python embedded projects
- Any `.v`, `.ino`, `.cpp`, `.py` source files
- Any existing READMEs

---

## Step 2 — Analyze Each Project
For each project folder, read the source files and identify:
1. What does this project do?
2. What hardware/board does it target?
3. What languages and tools were used?
4. What modules or components exist?
5. Are there testbenches?
6. What are the key technical specs (baud rate, resolution, voltage, frequency, etc.)?

**Priority projects to analyze first (in order):**
1. `HDL_Projects/uart transceiver` — UART transceiver in Verilog
2. `HDL_Projects/VGA_Controller` — VGA controller in Verilog
3. `HDL_Projects/Verilog_SCC` — Single-cycle CPU in Verilog
4. `Embedded-Programing_Projects/CacheEmulator/Air_Quality_Sensor_Project` — ESP32 IoT monitor

---

## Step 3 — Write a README for Each Project
For each of the 4 priority projects, create a `README.md` directly in that project's folder. The README must follow this exact structure:

### README Template

```markdown
# [Project Name] — [Platform/Tool]

[2-3 sentence description of what it does, how it works, and what makes it interesting]

---

## Demo

<!-- PLACEHOLDER: Add a GIF or photo here -->
![Demo](./docs/demo.gif)

*[One line describing what the demo shows]*

---

## Simulation / Waveforms (if applicable)

<!-- PLACEHOLDER: Add a screenshot of testbench waveforms -->
![Waveform](./docs/waveform.png)

---

## Architecture

[Draw a simple ASCII block diagram showing the major modules and data flow]

---

## Project Structure

[List all source files with a one-line description of each]

---

## Specifications

[Table of key specs: baud rate, resolution, clock speed, voltage, protocols, board, tool, etc. — extract from the actual source code]

---

## How It Works

[2-4 paragraphs explaining the design — clock generation, state machines, protocols, signal flow — written clearly enough that a hiring manager can follow it]

---

## Testbenches (if applicable)

[Describe what each testbench tests and how to run it in Vivado]

---

## How to Run

[Step-by-step instructions to open in Vivado, synthesize, program the board, and use the project]
```

---

## Step 4 — Write a Profile README
After completing the 4 project READMEs, create a file at the repo root called `PROFILE_README.md` with the following content pre-filled from the actual projects you analyzed:

- Name, contact, LinkedIn, GitHub
- A short bio (hardware EE student, SSRL satellite lab, FSAE EV accumulator)
- A skills table (Verilog, Altium Designer, C/C++, Python, UART/I2C/SPI/USB/WiFi)
- A featured projects table with links and one-line descriptions — use the ACTUAL project names and descriptions from what you read in the code
- SSRL and FSAE experience highlights
- Education: B.S. EE + Certificate in E-Mobility, UGA, July 2026

---

## Key Facts About Me (Use These in READMEs)
- **FPGA Board:** Nexys A7-T100 (primary), Basys3
- **HDL:** Verilog only (never VHDL or SystemVerilog)
- **UART project:** 115200 baud, full-duplex, echoes to PuTTY terminal, seven-segment display output
- **VGA project:** 640×480 @ 60Hz
- **ESP32 project:** Barometric pressure, air quality, humidity, temperature sensors; ThingSpeak cloud; data pushed every 5 minutes
- **Single-cycle CPU:** ARM-Educore-style ISA
- **PCB project (not in this repo):** 12V–5V LDO using LM1085IT 3A (Texas Instruments), designed in Altium Designer
- **SSRL:** UGA Small Satellite Research Laboratory, MOCI 6U CubeSat, Feb 2024–Present
- **FSAE Capstone:** 8-module, 660V, ~1,000 18650 cells, 12.33 kWh HV battery accumulator
- **Graduation:** July 2026, University of Georgia
- **Certificate:** E-Mobility

---

## Writing Style for READMEs
- Use clear, technical language — assume the reader is a hardware engineering recruiter or hiring manager
- Always include specific numbers and specs extracted from the actual source code (clock frequencies, bit widths, baud rates, state counts, etc.)
- Use present tense for descriptions ("implements", "generates", "displays")
- Keep bullet points short and punchy
- Every README should have at least one ASCII block diagram
- Mark image placeholders clearly with `<!-- PLACEHOLDER: ... -->` comments so I know exactly what photos/GIFs to capture

---

## What NOT to Do
- Do not suggest VHDL or SystemVerilog — Verilog only
- Do not fabricate specs — only use numbers you can verify from the source code
- Do not delete any source files
- Do not modify any `.v`, `.ino`, `.cpp`, or `.py` files — only create/edit README.md files
- Do not create new folders — write READMEs into the existing folder structure

---

## When You're Done
Print a summary that lists:
1. Every README you created and its file path
2. Any specs you could NOT find in the source code (so I can fill them in manually)
3. A prioritized list of images/GIFs I need to capture to complete the portfolio
