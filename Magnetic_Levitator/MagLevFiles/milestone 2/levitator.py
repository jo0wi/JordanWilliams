from machine import Pin, ADC
import time

# Define the ADC pin (Assume GP26 / ADC0)
hall_sensor = ADC(Pin(26))

while True:
    reading = hall_sensor.read_u16()  # Read 16-bit analog value (0-65535)
    voltage = (reading / 65535) * 3.3  # Convert to voltage (assuming 3.3V reference)
    print("ADC Reading:", reading, "Voltage:", voltage, "V")
    time.sleep(0.1)  # Delay for readability
