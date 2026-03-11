from machine import ADC, Pin, PWM
import time

# === Setup ===
hall = ADC(Pin(26))         # Hall sensor on GP26
pwm = PWM(Pin(16))          # PWM to MOSFET gate
pwm.freq(10000)             # Set PWM frequency (10 kHz)

# === Target voltage for halfway levitation ===
V_ref = 2.45  # halfway between 3.3V (down) and 1.6V (up)

# === Simple proportional controller gain ===
Kp = 20000  # Adjust this as needed — start high, reduce if unstable

# === PWM limits ===
MIN_DUTY = 10000
MAX_DUTY = 50000

print("Starting basic levitation controller...")

while True:
    # === Read sensor voltage ===
    raw = hall.read_u16()
    V_sensor = (raw / 65535) * 3.3

    # === Compute error (positive if magnet is too low) ===
    error = V_sensor - V_ref

    # === Compute control signal (proportional only) ===
    control = Kp * error

    # === Clamp and send to PWM ===
    duty = int(min(max(control, MIN_DUTY), MAX_DUTY))
    pwm.duty_u16(duty)

    # === Debug info ===
    print(f"Sensor: {V_sensor:.3f} V | Error: {error:.3f} | PWM: {duty}")
    
    time.sleep(0.01)  # 10ms loop
