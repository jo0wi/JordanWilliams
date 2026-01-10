# Air Quality Sensor Project

An ESP32-based air quality monitoring system that measures environmental parameters and transmits data to the cloud. This IoT project integrates multiple sensors to provide comprehensive air quality readings.

## Features

- Real-time temperature and humidity monitoring using DHT11 sensor
- Atmospheric pressure measurement with BMP280 sensor
- Dust density detection using GP2Y1010AU0F dust sensor
- Thermistor-based temperature sensing with Steinhart-Hart equation
- LCD display for local data visualization
- WiFi connectivity for cloud data transmission to ThingSpeak
- Enterprise WPA2 WiFi authentication support

## Hardware Components

- ESP32 microcontroller
- DHT11 temperature and humidity sensor
- BMP280 barometric pressure sensor
- GP2Y1010AU0F dust sensor
- NTC thermistor
- 16x2 I2C LCD display
- WiFi module (integrated in ESP32)

## Technologies Used

- Arduino IDE / ESP32 framework
- C++ programming
- I2C communication protocol
- SPI communication protocol
- WiFi connectivity
- ThingSpeak IoT platform
- Steinhart-Hart thermistor equation

## Setup Instructions

1. Install required libraries in Arduino IDE:
   - Adafruit_Sensor
   - Adafruit_BMP280
   - DHT
   - LiquidCrystal_I2C
   - WiFi
   - ThingSpeak

2. Configure WiFi credentials in `auth.h`:
   ```cpp
   const char* ssid = "your_wifi_ssid";
   const char* password = "your_wifi_password";
   ```

3. Update ThingSpeak channel information in the code:
   - Channel number
   - Write API key

4. Connect sensors according to pin definitions:
   - DHT11: Pin 2
   - Dust sensor LED: Pin 1
   - Dust sensor output: Pin 0
   - Thermistor: Pin 3
   - I2C LCD: Default pins (SDA: 21, SCL: 22)

5. Upload the code to ESP32 board

## Usage

1. Power on the device
2. The system will connect to WiFi and begin measurements
3. Sensor data is displayed on the LCD
4. Data is periodically sent to ThingSpeak for remote monitoring

## Data Parameters

- Temperature (°F and °C)
- Relative Humidity (%)
- Atmospheric Pressure (hPa)
- Altitude (meters)
- Dust Density (mg/m³)

## Calibration

- Dust sensor calibration constants are predefined
- Thermistor uses Steinhart-Hart coefficients for accurate temperature conversion
- BMP280 provides factory-calibrated pressure readings

## Applications

- Indoor air quality monitoring
- Environmental sensing
- Weather station
- IoT data logging
- Smart home automation

## Future Enhancements

- Add GPS for location-based data
- Implement data averaging and filtering
- Add alert system for poor air quality
- Battery-powered operation with sleep modes
- Mobile app for remote monitoring