# Lab 3 — MQTT Light Control with Tkinter GUI

**Topics:** Connecting the M5StickC Plus to WiFi, publishing and subscribing to MQTT topics, and building a Tkinter GUI on the host computer to mirror the device's screen state.

## Reflection

The objective of this lab was to learn how to connect the M5StickC Plus to the internet using MQTT and then create a GUI in Tkinter to control the M5StickC Plus's screen.

One area where I could have done better was the MQTT loop — reading from and writing to the topic — since I could not figure out how to read from the MQTT topic and have the read trigger the light to toggle. I also should have stored my WiFi password in a separate, gitignored file rather than embedding it in the source.

For `controller.py`, I could have laid out the Tkinter window to be as functional as the reference solution — for example, the way the reference incorporated color mixing in the GUI to mirror what was shown on the M5StickC Plus.

The hardest part of the lab for me was figuring out how to use MQTT to publish a status from one end and read it on the other to keep the device and GUI in sync. Connecting the device to WiFi was straightforward.

## Files

| File | Purpose |
|---|---|
| `lab3_light/` | M5StickC Plus MQTT light sketch |
| `program controller.py` | Tkinter GUI MQTT controller |
