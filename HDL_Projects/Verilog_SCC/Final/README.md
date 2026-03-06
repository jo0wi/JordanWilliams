# Verilog Single-Cycle CPU — ARM-Educore ISA (Verilog / Icarus Verilog)

A 32-bit single-cycle CPU implemented in Verilog with a custom ARM-Educore-style instruction set architecture. The processor executes the full IF -> ID -> EXE -> MEM -> WB datapath in a single clock cycle, supports 16 general-purpose 32-bit registers, a custom multiply microcode engine, and terminates by asserting a HALT flag — verified by a self-checking testbench that compares post-execution memory against a compiler-generated reference CSV.

---

## Demo

<!-- PLACEHOLDER: Capture a GTKWave screenshot showing clk, rst, programCounter incrementing by 4, halt_f asserting at program end, and key register writes across a bubble sort or float-add run. -->
![Demo](./docs/demo.png)

*GTKWave waveform showing the SCC executing a test program and asserting HALT after completion*

---

## Simulation / Waveforms

<!-- PLACEHOLDER: Capture a GTKWave screenshot showing instruction_memory_v (fetched instruction), ALU result wire, and register write-back across several clock cycles for the test_case program. -->
![Waveform](./docs/waveform.png)

---

## Architecture

```
              +----------------------------------------------+
  clk, rst -->|                  scc_f25_top                  |
              |                                              |
              |  +-----+  instruction  +-----------+        |
              |  | inf |<--------------| instr +   |        |
              |  | (IF)|  programCntr  | data mem  |        |
              |  +--+--+               +-----+-----+        |
              |     | instruction            | data_in      |
              |     v                        |              |
              |  +------+  control signals   |              |
              |  |  id  |--------------------> all stages   |
              |  | (ID) |                    |              |
              |  +--+---+                    |              |
              |     |                        |              |
              |     v                        |              |
              |  +------+  +-------+         |              |
              |  | regs |->|  exe  |         |              |
              |  |(REGS)|  | (EXE) |         |              |
              |  +------+  +---+---+         v              |
              |                | alu_Result  data_in        |
              |                v          +------+          |
              |            +------+  <----| data |          |
              |            | mem  |       | mem  |          |
              |            |(MEM) |       +------+          |
              |            +--+---+                         |
              |               |                             |
              |               v                             |
              |            +------+                         |
              |            |  wb  |--> write_data -> regs   |
              |            | (WB) |                         |
              |            +------+                         |
              |  MUL: instruction_rom + test_uC             |
              +----------------------------------------------+
```

---

## Project Structure

| File | Description |
|------|-------------|
| scc_f25_top.v | Top-level — instantiates SCC core and unified instruction/data memory |
| scc.v | SCC core — wires all pipeline stage modules together |
| inf.v | Instruction Fetch (IF) — PC, branch resolution, microcode dispatch |
| id.v | Instruction Decode (ID) — decodes 32-bit instruction into all control signals |
| exe.v | Execute (EXE) — instantiates ALU, evaluates branch conditions |
| alu.v | ALU — ADD, SUB, AND, OR, XOR, NOT with NZCV flag outputs |
| regs.v | Register file — 16 x 32-bit registers, synchronous write, async read |
| mem.v | Memory stage (MEM) — generates load/store address and control signals |
| wb.v | Write-Back (WB) — mux between ALU result and memory data for register write |
| instruction_and_data.v | 64 KB unified instruction + data memory; dumps memory on HALT |
| instruction_rom.v | Microcode ROM — stores multiply sub-instructions |
| test_uC.v | Microcode sequencer — replays multiply micro-ops over multiple cycles |
| scc_tb.v | Self-checking testbench — compares post-HALT memory dump to emulator CSV |
| examples/bubble_sort/bubble_sort.asm | Example assembly: bubble sort |
| examples/floatAdd/floatAdd.asm | Example assembly: floating-point addition |
| charts_and_docs/Group5_SCC.pdf | Full design documentation and ISA reference |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Architecture | Single-cycle (IF -> ID -> EXE -> MEM -> WB) |
| ISA | ARM-Educore-style custom 32-bit ISA |
| Data width | 32-bit |
| Register file | 16 x 32-bit general-purpose (R0-R14 general; R15 = PC) |
| Memory | 64 KB unified instruction + data |
| ALU operations | ADD (1), SUB (2), AND (3), OR (4), XOR (5), NOT (6), MUL (microcode) |
| Condition flags | NZCV (negative, zero, carry, overflow) |
| Branch types | Unconditional, conditional (NZCV), branch-to-register |
| Instruction encoding | op[31:30], setFlags[28], alu_op[27:25], dst[24:21], op1[20:17], op2[16:13], imm[15:0] |
| Multiply | Multi-cycle microcode via test_uC + instruction_rom |
| Simulation tool | Icarus Verilog + GTKWave |
| Language | Verilog |

---

## How It Works

**Instruction Fetch (IF / inf).** The program counter increments by 4 each clock cycle. The inf module handles three PC update cases: normal increment (+4), branch (PC + sign-extended 16-bit immediate), and register-branch (writing to R15 redirects PC to the register value). When MUL is detected, setCatch is asserted and IF switches to fetch micro-instructions from instruction_rom via test_uC, holding the main PC frozen until multiplication completes.

**Instruction Decode (ID / id).** A combinational always block parses the two MSBs of the instruction (instruction[31:30]) as the major opcode class: 00 for ALU-with-immediate, 01 for ALU-with-register, 10 for load/store, and 11 for branch/system. It drives alu_Flag, load_Flag, store_Flag, branch_Flag, write_to_reg_Flag, immediate_Flag, shift_Flag, mov_flag[1:0], and alu_Instruct[2:0] to all downstream stages.

**Execute (EXE + ALU).** The ALU takes two 32-bit operands (register values or sign-extended immediate) and a 3-bit operation code. It computes the result and NZCV flags. Flags are only committed when flag_Flag is asserted, enabling CMP-style instructions that update condition codes without writing a destination register.

**Multiply Microcode.** MUL (ALU opcode 000) is implemented as multi-cycle microcode. The decoder asserts setCatch, the IF stage routes instruction fetch through test_uC and instruction_rom, which replay a sequence of ADD and shift operations to compute the product. setCatch clears when the microcode finishes and normal PC advance resumes.

**Memory / Write-Back.** Load instructions read from the unified memory at the ALU-computed address. Store instructions write a register value to that address. The write-back mux selects between the ALU result and the memory read data and writes to the destination register on the next rising clock edge.

**Self-Checking Testbench.** scc_tb.v runs until halt_f is asserted ("Apollo has Landed!"), then opens both scc_out.txt (hardware memory dump written by $writememh) and dataoutput.csv (emulator reference). It reads each address-value pair from both files, syncs on matching addresses, and prints PASS or FAIL for each comparison. A complete match ends with "PASS: all CSV memory values match DUT dump."

---

## Testbenches

| Testbench | Program | Description |
|-----------|---------|-------------|
| scc_tb.v | Any output.mem | Full SCC self-checking memory comparison |
| examples/class_examples/Group1/scc_tb.v | lut.asm | Sine-wave LUT |
| examples/class_examples/Group2/scc_tb.v | simple_crc.asm | CRC computation |
| examples/class_examples/Group5/scc_tb.v | floatAdd.asm | Floating-point addition |
| examples/bubble_sort/ | bubble_sort.asm | Bubble sort |

**To compile and simulate (from the Final/ directory):**

```
iverilog -g2005 -o scc_tb.out scc_tb.v scc_f25_top.v scc.v instruction_and_data.v exe.v id.v inf.v mem.v regs.v wb.v alu.v instruction_rom.v test_uC.v
vvp scc_tb.out
```

Ensure output.mem and dataoutput.csv are in the working directory before running.

**To view waveforms:**

```
gtkwave dump.vcd
```

---

## How to Run

1. **Assemble a program** — Use the course assembler to convert an .asm file to output.mem. Pre-assembled examples with matching dataoutput.csv files are in each examples/ subdirectory.
2. **Compile** — Run the Icarus Verilog command above from Final/.
3. **Simulate** — Execute vvp scc_tb.out. Wait for HALT and check the console for PASS/FAIL per address.
4. **Inspect waveforms** — Open dump.vcd in GTKWave. Add clk, rst, programCounter, halt_f, instruction_memory_v, and key ALU/register signals.
