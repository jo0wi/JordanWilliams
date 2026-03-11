from machine import ADC, Pin, PWM
import time

# === Setup ===
hall = ADC(Pin(26))         # Hall sensor on GP26 / ADC0
pwm = PWM(Pin(16))          # PWM to gate of MOSFET
pwm.freq(10000)             # 10 kHz

# === Target voltage for halfway levitation (between 3.3V and 1.6V) ===
V_ref = 2.45  # halfway point voltage

# === Discrete controller coefficients (from Simulink) ===
b = [2439.9815, -4484.7955, 2044.8225]
a = [1.0, -1.9999999, 0.9999999]

e = [0, 0, 0]  # error history
u = [0, 0, 0]  # output history

# === PWM duty limits ===
MIN_DUTY = 10000
MAX_DUTY = 50000
SCALE_DOWN = 50  # scale controller output

print("Starting control loop...")

while True:
    # === Read the sensor the reliable way ===
    raw = hall.read_u16()
    V_sensor = (raw / 65535) * 3.3

    # === Compute error ===
    e[0] = V_sensor - V_ref

    # === Difference equation controller ===
    u[0] = (b[0]*e[0] + b[1]*e[1] + b[2]*e[2]
           - a[1]*u[1] - a[2]*u[2])

    # === Scale and clamp ===
    scaled_output = u[0] / SCALE_DOWN
    duty = int(min(max(scaled_output, MIN_DUTY), MAX_DUTY))
    pwm.duty_u16(duty)

    # === Print debug info ===
    print(f"Sensor: {V_sensor:.3f} V | Error: {e[0]:.3f} | u: {u[0]:.2f} | PWM: {duty}")

    # === Shift history ===
    e[2], e[1] = e[1], e[0]
    u[2], u[1] = u[1], u[0]

    time.sleep(0.01)  # loop delay 10ms
