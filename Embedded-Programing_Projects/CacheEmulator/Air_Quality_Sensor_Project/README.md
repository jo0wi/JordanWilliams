# ESP32 Air Quality Monitor — ESP32 / Arduino / ThingSpeak

A multi-sensor IoT air quality monitor implemented in C++ (Arduino framework) on the ESP32. The device simultaneously reads barometric pressure, altitude, humidity, temperature (via thermistor and Steinhart-Hart equation), and particulate dust density, displays live readings on a 16x2 I2C LCD, and pushes all five data fields to ThingSpeak cloud every ~6 seconds for remote monitoring and data logging.

---


## Architecture

```
                        +--------------------------------+
  BMP280 (I2C, 0x77) -->|                                |
  DHT11 (GPIO 2)  ----->|           ESP32                |--> Serial (115200)
  Dust sensor     ----->|                                |
    LED (GPIO 1)        |  Sensors --> compute --> LCD   |
    ADC (GPIO 0)        |             --> ThingSpeak     |
  Thermistor (GPIO 3)-->|                                |
  LCD (I2C, 0x27) <-----|                                |
                        +--------+---+-------------------+
                                 |   |
                            WiFi |   | WPA2-Enterprise
                                 v   v
                          ThingSpeak Cloud
                          Channel 2412781
                          Fields 1-5
```

---

## Project Structure

| File | Description |
|------|-------------|
| Air_Quality_Sensor_Project.ino | Main Arduino sketch — sensor reads, display, ThingSpeak upload |
| auth.h | WiFi credentials and ThingSpeak API key (not committed — add your own) |

---

## Specifications

| Parameter | Value |
|-----------|-------|
| Microcontroller | ESP32 |
| Framework | Arduino (C++) |
| Serial baud rate | 115200 baud |
| Barometric pressure sensor | BMP280 (I2C, address 0x77) |
| Humidity sensor | DHT11 (GPIO 2) |
| Temperature sensor | NTC thermistor (GPIO 3, ADC) with Steinhart-Hart equation |
| Thermistor bias resistor | R1 = 13,180 ohm |
| Thermistor supply voltage | V_in = 5 V |
| Dust sensor | Optical IR LED/ADC (LED on GPIO 1, ADC on GPIO 0) |
| Dust conversion ratio | 0.13 ug/m3 per unit |
| Dust density ADC resolution | 12-bit (0-4095), 3.3 V reference |
| LCD | 16x2 I2C LCD (address 0x27) |
| Cloud platform | ThingSpeak (channel 2412781) |
| Upload interval | ~6 seconds (three 2-second LCD display cycles) |
| WiFi | WPA2-Personal or WPA2-Enterprise (configurable via USE_EAP flag) |
| AQI levels | 6 levels: I (<=35), II (<=75), III (<=115), IV (<=150), V (<=250), VI (<=500) ug/m3 |
| Language | C++ (Arduino) |

---

## How It Works

**Sensor Acquisition.** On each loop iteration, the ESP32 reads atmospheric pressure (kPa) and altitude (meters above sea level at 1013 hPa baseline) from the BMP280 over I2C, and humidity (%) from the DHT11 over a single-wire digital protocol.

**Temperature Calculation.** The thermistor forms a voltage divider with a 13,180-ohm resistor powered by 5 V. The ADC reads the midpoint voltage on GPIO 3 (12-bit, 3.3 V reference). The thermistor resistance is computed as Rt = Vout * R1 / (Vin - Vout), then converted to temperature in Celsius using the three-coefficient Steinhart-Hart equation: 1/T = A + B*ln(Rt) + C*ln(Rt)^3 (A = 0.001129148, B = 0.000234125, C = 8.76741e-8). The result is converted to Fahrenheit for display.

**Dust Density Measurement.** A 280-microsecond LED pulse on GPIO 1 illuminates airborne particles. The ADC on GPIO 0 samples the scattered-light voltage immediately after the pulse. A 10-sample rolling average filter (`Filter()`) smooths the reading, then the voltage is converted to dust density in ug/m3 using: density = voltage * 0.13 * 10000. The result maps to one of six AQI levels (I through VI) by comparing against standard PM2.5 breakpoints.

**LCD Display.** The 16x2 LCD cycles through three 2-second screens: (1) temperature in degrees F and humidity %, (2) atmospheric pressure in kPa and altitude in meters, (3) AQI level string.

**ThingSpeak Upload.** After the three display cycles, all five sensor values are pushed to ThingSpeak in a single writeFields() call: Field 1 = pressure (kPa), Field 2 = temperature (F), Field 3 = altitude (m), Field 4 = humidity (%), Field 5 = dust density (ug/m3).

**WiFi Connection.** The sketch supports both WPA2-Personal (ssid + password) and WPA2-Enterprise (EAP identity/password, for university/enterprise networks) via a compile-time USE_EAP flag defined in auth.h.

---

## How to Run

1. **Set up auth.h** — Create auth.h with your WiFi SSID, password (and EAP credentials if needed), and ThingSpeak write API key. A template:
   ```cpp
   const char* ssid = "YourNetwork";
   const char* WPA_PASSWORD = "YourPassword";
   ```
2. **Install libraries** — In Arduino IDE, install: Adafruit BMP280, Adafruit Unified Sensor, DHT sensor library, ThingSpeak, LiquidCrystal I2C, Wire (built-in), WiFi (built-in ESP32).
3. **Wire the hardware** — Connect BMP280 to ESP32 I2C (SDA/SCL), DHT11 data to GPIO 2, thermistor divider output to GPIO 3, dust sensor LED to GPIO 1 and ADC to GPIO 0, LCD to I2C (address 0x27).
4. **Select board** — In Arduino IDE, select the correct ESP32 board and COM port.
5. **Upload** — Compile and flash. Open the Serial Monitor at 115200 baud to see live sensor readings.
6. **View cloud data** — Log in to ThingSpeak and open channel 2412781 to see the five field graphs updating in real time.
