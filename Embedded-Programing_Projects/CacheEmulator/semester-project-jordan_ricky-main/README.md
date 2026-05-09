# ELEE 2045 Final Project — Home Security & Light Control

A home-security and light-control system that combines two M5StickC Plus devices, two USB webcams, MQTT, YOLO person-detection, and a Tkinter GUI into a single application. The GUI lets the user toggle the M5StickC LEDs, view either webcam feed live, and rely on the cameras to start recording video and saving timestamped screenshots whenever a person is detected.

> Course: ELEE 2045 Embedded Systems · Spring 2023.
> Group: Jordan Williams + Ricky.

---

## Goals

A home security system and light control built from M5StickC Plus + webcam integration:

1. GUI in Tkinter / Pygame.
2. Control 2 M5StickC Pluses — light, color, on/off status.
3. Detect people in webcam feeds.
4. Save a timestamped screenshot whenever a person is detected.
5. Switch between the 2 cameras inside the GUI.

---

## External Repository

The final code and demo video live in the original course repository:

- Final project file: <https://github.com/elee2045sp23/semester-project-edwin_ricky/blob/main/homeSecurityFINAL.py>
- Project demo video: <https://github.com/elee2045sp23/semester-project-edwin_ricky/blob/main/projectVideo.mp4>

---

## Finished Features

1. Light on/off control through both the Tkinter GUI and the M5StickC button.
2. M5StickC color control.
3. Light-status indicator in the GUI.
4. Two M5StickC Plus devices connected concurrently.
5. Live camera feed shown inside Tkinter.
6. Switch between the two connected camera outputs from the GUI.
7. YOLO person-detection on each camera independently.
8. Each camera operates independently of the other.
9. Each camera starts video recording the moment a person is detected.
10. Each camera saves a timestamped still image whenever a person is in view.

---

## Work Split

| Member | Contribution |
|--------|-------------|
| Jordan | M5StickC Arduino code, light-control GUI, MQTT integration |
| Ricky | Camera detection, camera-Tkinter integration, recording + still capture |
| Together | Integration of the two halves of the project |

---

## Known Quirks

1. A video file is created at the start of the run even if the camera never records. If the camera does record, the file is a normal video; if it does not, the file exists but is empty.
2. There are occasional white flashes in the live Tkinter camera feed. They do not appear in the recorded video, the saved stills, or the standalone OpenCV preview window — only in the embedded Tkinter view.

---

## Setup — Required Edits Before Running

1. **Output directory.** Update the `outA`, `outB`, and `directory` variables (inside the `mainA()` / `mainB()` functions) to point at a folder where you want videos and stills saved. If you target a new folder, create it before running — the program will not create it for you, and missing folders cause silent save failures.
2. **YOLO model paths.** Update the `netA` (`yolov5a.onnx`), `netB` (`yolov5b.onnx`), and `classes.txt` paths (`with open(...)` immediately after `netB`) to the locations of those files on your machine. The program will not start if these paths are wrong.

---

## Shutdown — Important

The program **must** be closed via the **Close All** button inside the Tkinter window. If you close it any other way:

- The camera functions keep "using" the video files they created.
- You will be unable to move, edit, or delete those files until the Python process is killed manually in VS Code.
- Adding `running = False`, `capture.release()`, and `capture2.release()` after `root.mainloop` does **not** fix the issue when the window is closed via the OS `X` button.
- The Close All button releases the cameras *before* `root.destroy` is called — that ordering is the only sequence we found that cleanly shuts everything down.
