# Lab 4 — Capacitor Simulation + Bluetooth-Driven Game

**Topics:** Modeling RC capacitor charge/discharge in Python with Pygame visualization, and connecting the M5StickC Plus to a host PC over Bluetooth so accelerometer data can drive a game's input.

## Reflection

The objective of this lab was twofold: (1) use Python to simulate the charging and discharging of a capacitor in real time using Pygame, and (2) connect the M5StickC Plus to my computer via Bluetooth and use the streamed data to control a game.

Connecting the device over Bluetooth and retrieving data was the most straightforward part of the lab.

For Part 2, the main thing that gave me trouble was getting accelerometer data to drive the game in place of keyboard input. The rest of Part 2 had its own detail issues, but the core hurdle was the controls themselves.

For Part 1, I was initially unsure how to translate the capacitor equation into Python. I figured it out, but my final hurdle was that the bar graph and simulation were rendering upside-down because of a sign error in my equation.

## Files

| File | Purpose |
|---|---|
| `lab4_controller.ino` | M5StickC Plus accelerometer-streaming sketch |
| `lab4_part1.py` | Pygame capacitor charge/discharge simulator |
| `lab4_part2.py` | Bluetooth-driven Pygame game using M5 input |
