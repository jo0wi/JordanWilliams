from machine import ADC, PWM, Pin
import time

# === PINS ===
HALL_PIN = 26      # Hall sensor (position)
SHUNT_OP_PIN = 27  # Op-amp output from shunt
PWM_PIN = 16       # PWM to solenoid MOSFET

adc_pos = ADC(Pin(HALL_PIN))
adc_shunt = ADC(Pin(SHUNT_OP_PIN))
pwm = PWM(Pin(PWM_PIN))
pwm.freq(10000)

# === SYSTEM CONSTANTS ===
VREF = 3.3
ADC_MAX = 65535
R_SHUNT = 0.185      # Ohms
GAIN = 8.5           # Op-amp gain
dt = 0.001          # 10 kHz loop

# === TARGETS ===
TARGET_V = 2.05      # Desired Hall sensor voltage

# === OUTER LOOP GAINS (Position) ===
Kp_pos = 1.46e6
Kd_pos = 1.14e5
last_error = 0
alpha = 0.1          # Derivative smoothing
derivative = 750

# === INNER LOOP GAINS (Discrete Lead Compensator) ===
b0 = 0.3745
b1 = 0.0
a1 = 0.0107
e_prev = 0
u_prev = 0

# === CURRENT SPIKE DAMPING ===
CORRECTION_GAIN = 2000  # Adjust if needed
MAX_CORRECTION = 5000

# === PWM LIMITS ===
PWM_MIN = 100
PWM_MAX = 35000

# === STARTUP PULSE ===
pwm.duty_u16(25000)
time.sleep(0.2)

# === MAIN LOOP ===
while True:
    # --- Position Controller ---
    v_pos = adc_pos.read_u16() * VREF / ADC_MAX
    error = TARGET_V - v_pos
    d_raw = (error - last_error) / dt
    derivative = alpha * d_raw + (1 - alpha) * derivative
    last_error = error

    desired_current = Kp_pos * error + Kd_pos * derivative

    # --- Read current from op-amp diff amp ---
    v_shunt = adc_shunt.read_u16() * VREF / ADC_MAX
    measured_current = v_shunt / (R_SHUNT * GAIN)
    error_current = desired_current - measured_current

    # --- Lead Compensator (Inner loop) ---
    u_k = b0 * error_current + b1 * e_prev - a1 * u_prev

    # --- Damping correction if current is too high ---
    if measured_current > desired_current:
        correction = CORRECTION_GAIN * (measured_current - desired_current)
        correction = min(correction, MAX_CORRECTION)
        u_k -= correction

    # --- Clamp PWM and update ---
    duty = int(min(max(u_k, PWM_MIN), PWM_MAX))
    pwm.duty_u16(duty)

    # --- Update loop states ---
    e_prev = error_current
    u_prev = u_k

    time.sleep(dt)
