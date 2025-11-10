# 🧠 Verilog Single-Cycle CPU

A 32-bit single-cycle CPU designed in **Verilog** with a custom ARM-like instruction set and compiler.  
Built as the final project for my *Computer Architecture* course to demonstrate my understanding of instruction pipelines, control logic, and memory interaction.

---

## ⚙️ Features
- Single-cycle CPU architecture: **IF → ID → EXE → MEM → WB**
- 32 general-purpose registers
- Custom instruction set (load/store, arithmetic, branch)
- Memory-mapped I/O for simple peripherals
- Assembled from modular Verilog design files
- Micro Code module to handle multiply operations

---

## 🧰 Tools Used
- **Vivado / Icarus Verilog** – Design and simulation  
- **GTKWave** – Timing and waveform analysis    

---

## 🧪 Testing and Verification
- Each stage tested with self-checking testbenches  
- Final memory output verified against compiler-generated reference  
- Waveform inspection used for instruction trace validation  

### Example Waveform  
[Waveform Example](./docs/waveform_example.png)

---

## 📁 Repository Structure
