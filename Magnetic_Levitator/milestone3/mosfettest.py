from machine import Pin, PWM
import time

mosfet_trigger = PWM(Pin(16))
mosfet_trigger.freq(10000)  # 10 kHz

# Sweep PWM from 0% to 100%
for duty in range(0, 65535, 5000):
    mosfet_trigger.duty_u16(duty)
    print("Duty:", duty)
    time.sleep(1)
