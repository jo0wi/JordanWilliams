from machine import Pin, PWM, ADC
import time

# Setup PWM on GPIO 16 (for driving the MOSFET)
pwm = PWM(Pin(16))
pwm.freq(10000)  # 10 kHz PWM frequency

# Setup Hall sensor on GPIO 26 (ADC0)
hall = ADC(Pin(26))

# Function to convert ADC reading to voltage
def read_voltage():
    raw = hall.read_u16()
    voltage = (raw / 65535) * 3.3
    return voltage

print("Starting PWM sweep with Hall sensor readings...")

# Sweep from 0% to 100% in 10% steps
for duty_percent in range(0, 110, 10):
    # Convert percent (0–100) to duty_u16 (0–65535)
    duty_value = int((duty_percent / 100) * 65535)
    pwm.duty_u16(duty_value)

    # Read Hall sensor
    voltage = read_voltage()

    # Print results
    print(f"Duty: {duty_percent}% | PWM: {duty_value} | Sensor Voltage: {voltage:.3f} V")

    # Wait 1 second
    time.sleep(1)

# Turn off PWM after sweep (optional)
pwm.duty_u16(0)
print("PWM sweep complete.")
