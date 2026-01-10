# M5Stick Bluetooth Module

A Bluetooth Low Energy (BLE) server implementation for M5StickC Plus that demonstrates wireless communication and button input transmission. This project showcases embedded Bluetooth connectivity and real-time data streaming.

## Features

- BLE server with custom service and characteristic UUIDs
- Button press detection and transmission
- Connection status monitoring
- Optimized Bluetooth connection parameters for faster data transfer
- Automatic advertising restart on disconnection
- IMU initialization (for future sensor integration)

## Hardware Components

- M5StickC Plus microcontroller
- Built-in button (GPIO 37)
- Integrated IMU (MPU6886) - initialized but not used in current implementation
- Bluetooth 4.2 module (integrated)

## Technologies Used

- Arduino IDE / ESP32 framework
- C++ programming
- Bluetooth Low Energy (BLE) protocol
- ESP32 BLE libraries
- M5StickC Plus SDK

## Setup Instructions

1. Install M5StickC Plus board support in Arduino IDE
2. Install required libraries:
   - M5StickCPlus
   - BLEDevice
   - BLEServer
   - BLEUtils
   - BLE2902

3. Connect M5StickC Plus via USB
4. Select board: M5Stick-C-Plus
5. Upload the code

## Usage

1. Power on the M5StickC Plus
2. The device will start advertising as "M5StickCPlus-Jordan"
3. Use a BLE scanner app (like nRF Connect) on another device
4. Connect to the advertised service
5. Monitor the characteristic for button press notifications
6. Press the front button to send data (1 for pressed, 0 for released)

## BLE Configuration

- **Service UUID**: e6e84dae-5a39-4c07-9a4b-ae031d4d4cd7
- **Characteristic UUID**: 5130bfef-4533-4945-91c0-a2dfed90bffa
- **Properties**: Read, Notify
- **Connection Parameters**: Min interval 6, Max interval 12 (for faster response)

## Data Packet Structure

```cpp
#pragma pack(1)
typedef struct {
  uint8_t buttonA;  // 1 = pressed, 0 = released
} Packet;
```

## Applications

- Wireless input device
- Remote control systems
- IoT button sensor
- BLE prototyping and testing
- Embedded system communication

## Debug Files

- `debug.cfg`: OpenOCD configuration for debugging
- `debug_custom.json`: VS Code debug configuration
- `esp32.svd`: ESP32 System View Description for debugging

## Future Enhancements

- Add IMU data transmission (accelerometer, gyroscope)
- Implement multiple buttons
- Add battery level monitoring
- Create custom BLE client application
- Add encryption and security features
- Implement over-the-air (OTA) updates