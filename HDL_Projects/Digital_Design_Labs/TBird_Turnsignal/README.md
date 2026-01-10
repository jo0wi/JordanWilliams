# Thunderbird Turn Signal

A finite state machine (FSM) implementation of the classic Thunderbird automobile sequential turn signal pattern. This FPGA project recreates the iconic sequential lighting sequence used in Ford Thunderbird cars from the 1960s.

## Features

- Sequential turn signal animation (LA → LB → LC for left, RA → RB → RC for right)
- Finite state machine design
- 1 Hz timing for realistic turn signal speed
- Left and right turn signal inputs
- Reset functionality

## Technologies Used

- Verilog HDL
- Finite State Machine (FSM) design
- Clock division
- Xilinx Vivado Design Suite
- Basys-3 development board

## Hardware Requirements

- Basys-3 FPGA board
- 6 LEDs for turn signal outputs (LA, LB, LC, RA, RB, RC)
- 2 input switches/buttons for Left/Right signals
- Reset button

## Implementation Details

### State Machine
- **S_Off**: Idle state, waiting for turn signal input
- **S_L1-S_L3**: Left turn sequence states
- **S_R1-S_R3**: Right turn sequence states

### Timing
- 1 Hz clock divider for turn signal timing
- Each state represents one "step" in the sequence
- Transitions automatically through sequence when turn signal is active

### Signal Outputs
- Left turn: LA (front) → LB (middle) → LC (rear)
- Right turn: RA (front) → RB (middle) → RC (rear)

## File Structure

- `TurnSignal_FSM.v`: Main FSM logic
- `ClkDiv.v`: Clock divider for 1 Hz timing
- `TB_FSM_1Hz_Top.v`: Top-level module integration
- Vivado project files

## Usage

1. Apply Left or Right input to activate respective turn signal
2. Observe sequential LED illumination pattern
3. Sequence repeats while input is held
4. Returns to off state when input is released

## Learning Outcomes

This project demonstrates:
- Finite state machine design and implementation
- Sequential logic and state transitions
- Clock domain crossing and timing control
- Automotive electronics concepts
- Historical technology recreation