# Ball & Beam Control System — MATLAB / Simulink

A modeling and simulation project for a classic ball-and-beam control problem. The repo contains an open-loop plant model, a closed-loop controller, a "golden" reference model used for unit-style verification, and recorded hardware data used to validate the simulated controller against a physical bench rig.

> Course project — Spring 2026.
> Toolchain: MATLAB R2024+ / Simulink.

---

## Project Structure

| File | Description |
|---|---|
| `Course_Project_S26.mlx` | MATLAB Live Script — full project narrative, plant derivation, controller design, results |
| `ball_beam_openloop.slx` | Open-loop Simulink model — plant only, no feedback |
| `ball_beam_closedloop.slx` | Closed-loop Simulink model — plant + controller |
| `ball_beam_closedloop.slxc` | Simulink cache for the closed-loop model |
| `ball_beam_golden_model.slx` | Reference "golden" model used to validate controller behavior |
| `ball_beam_sim.slx` | End-to-end simulation harness |
| `hardware_data.csv` | Logged data from the physical bench rig (used for plant / controller validation) |
| `slprj/` | Simulink build artifacts |

---

## What's Modeled

The plant is a ball rolling along a beam tilted by a servo. Position is captured via a sensor; the servo torque tilts the beam to drive the ball toward a setpoint. The control objective is to reject perturbations and track step changes in target position with reasonable settling time and minimal steady-state error. Both the open-loop response and a tuned closed-loop controller are simulated, then compared against the recorded `hardware_data.csv` to characterize plant fidelity.

---

## How to Run

1. Open MATLAB and `cd` into this folder.
2. Open `Course_Project_S26.mlx` (Live Script). Run the sections top-to-bottom; the script opens the relevant Simulink models and steps through plant identification, controller tuning, and validation.
3. To simulate the closed-loop model directly, open `ball_beam_closedloop.slx` and click **Run**.
4. To compare simulation against hardware, run the corresponding Live Script section that imports `hardware_data.csv` and overlays the recorded trajectory on the simulated response.
