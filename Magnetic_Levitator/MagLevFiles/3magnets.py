from machine import ADC, PWM, Pin
import time

# === HARDWARE SETUP ===
HALL_PIN = 26
PWM_PIN = 16
adc = ADC(Pin(HALL_PIN))
pwm = PWM(Pin(PWM_PIN))
pwm.freq(10000)

# === SYSTEM CONFIGURATION ===
VREF = 3.3
ADC_MAX = 65535
TARGET_VOLTAGE = 2.05
dt = 0.001

# === CONTROLLER GAINS (from your TF) ===
Kp = 1.45e6
Kd = 1.14e5
Ki = 0

# === CONTROLLER STATE ===
integral = 0
last_error = 0
derivative = 0
alpha = 0.1  # Derivative smoothing
PWM_MIN = 100
PWM_MAX = 35000
count = 0

# === INITIAL PWM PULSE TO "GRAB" MAGNET ===
pwm.duty_u16(25000)
time.sleep(0.2)

# === CONTROL LOOP ===
while True:
    voltage = adc.read_u16() * VREF / ADC_MAX
    error = TARGET_VOLTAGE - voltage

    # Derivative smoothing
    d_raw = (error - last_error) / dt
    derivative = alpha * d_raw + (1 - alpha) * derivative

    # PID calculation (only P and D in this TF)
    output = Kp * error + Kd * derivative
    duty = int(min(max(output, PWM_MIN), PWM_MAX))

    pwm.duty_u16(duty)

    if count % 20 == 0:
        print(f"V: {voltage:.3f} | E: {error:.3f} | D: {derivative:.2f} | PWM: {duty}")
    
    last_error = error
    count += 1
    time.sleep(dt)
