# Lab 5 — MediaPipe + YOLOv5 with M5StickC Plus

**Topics:** Using MediaPipe pose tracking and YOLOv5 object detection on a webcam feed, then linking the M5StickC Plus as an input device — first as a button-driven exercise rep counter, then as a YOLOv5 multi-class detector.

## Reflection

The objective of this lab was to use MediaPipe and YOLOv5 alongside our computer webcams and the M5StickC Plus to (1) build an exercise repetition counter and (2) detect three different object classes from the YOLOv5 list.

In Part 1 I had trouble using the M5StickC Plus button press to indicate the up and down position of an exercise. Looking at the posted solution, I now see it would have been beneficial to use threading and the Bluetooth streaming approach from Lab 4 instead of polling.

In Part 2, the key takeaways from the solution are organizing the code into helper functions to keep the main loop clean, and using the `sys` and `time` libraries to better pace and time-stamp the detections.

## Files

| File | Purpose |
|---|---|
| `lab5_part1.ino` | M5StickC Plus rep-counter button sketch |
| `lab5_part1.py` | MediaPipe-based rep counter (Part 1) |
