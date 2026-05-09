# M5StickC Plus BLE Button — Arduino / ESP32

A Bluetooth Low Energy (BLE) GATT server running on the M5StickC Plus that streams the front-button state to any connected client over a notify-capable characteristic. Used as the lab-4 Bluetooth exercise in the ELEE 2045 Embedded Systems course.

---

## Project Structure

| File | Description |
|------|-------------|
| `bluetoothex_ino.ino` | Arduino sketch — BLE server, characteristic, button-poll-and-notify loop |
| `debug.cfg` | OpenOCD configuration for ESP32 hardware debugging |
| `debug_custom.json` | VS Code launch configuration |
| `esp32.svd` | ESP32 System View Description for register-aware debugging |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Microcontroller | M5StickC Plus (ESP32-PICO) |
| Framework | Arduino (C++) |
| Bluetooth | BLE 4.2 GATT server |
| Advertised name | `M5StickCPlus-Jordan` |
| Service UUID | `e6e84dae-5a39-4c07-9a4b-ae031d4d4cd7` |
| Characteristic UUID | `5130bfef-4533-4945-91c0-a2dfed90bffa` |
| Characteristic properties | Read, Notify |
| Min preferred connection interval | 0x06 (7.5 ms) |
| Max preferred connection interval | 0x0C (15 ms) |
| Button input | Front button on GPIO 37 |
| Payload | 1-byte struct: `{ uint8_t buttonA; }` (1 = pressed, 0 = released) |

---

## How It Works

On boot the sketch initializes the M5StickC Plus, configures the IMU, creates a BLE server and service, and exposes a single characteristic with both read and notify properties. It then begins advertising under the device name `M5StickCPlus-Jordan`. When a client connects, the main loop debounces the front button on GPIO 37 (logic-inverted to give 1 = pressed) and calls `notify()` on every iteration so the client receives real-time button updates. If the client disconnects, the loop calls `startAdvertising()` again so the device is rediscoverable without a manual reset.

The advertised connection interval is intentionally short (7.5-15 ms) to minimize button-press-to-receive latency.

---

## How to Run

1. Install the **M5StickC Plus** board package and the libraries `M5StickCPlus`, `BLEDevice`, `BLEServer`, `BLEUtils`, and `BLE2902` in the Arduino IDE.
2. Open `bluetoothex_ino.ino`, select board `M5Stick-C-Plus`, choose the correct COM port, and upload.
3. On a phone or laptop, open a BLE scanner (e.g. **nRF Connect**), find `M5StickCPlus-Jordan`, and connect.
4. Subscribe to notifications on characteristic `5130bfef-4533-4945-91c0-a2dfed90bffa`.
5. Press the front button — observe the value alternate between `0x01` (pressed) and `0x00` (released).

---

## Packet Layout

```cpp
#pragma pack(1)
typedef struct {
    uint8_t buttonA;   // 1 = pressed, 0 = released
} Packet;
```

Packed-byte struct so the same definition can be reused on both ESP32 and Python clients without alignment surprises.
