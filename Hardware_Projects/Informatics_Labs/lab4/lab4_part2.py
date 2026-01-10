import asyncio
from bleak import BleakScanner
from bleak import BleakClient
import time
import threading
import pygame
import random
import struct

global accx, accy, accz, batt
running = True

def async_thread():
    print("new thread")

    async def run():
        scanner = BleakScanner()
        devices = await scanner.discover(5,return_adv=True)
        for d, info in devices.items():
            if d == ("E8:9F:6D:09:2F:F6"):
                print(d,info)
        def notification_callback(sender, payload):
            global accx
            global accy
            global accz
            global batt
            global btn
            accx, accy, accz, batt, btn = struct.unpack("<fffh", payload)
            #return accx, accy, accz, batt
        
            print(accx, accy, accz, batt, btn)


        async with BleakClient("E8:9F:6D:09:2F:F6") as client:
            await client.start_notify('5130bfef-4533-4945-91c0-a2dfed90bffa', notification_callback)
            while running:
                await asyncio.sleep(1)

    asyncio.run(run())

def my_game():
    
    pygame.init()

    screen_width = 800
    screen_height = 600
    screen = pygame.display.set_mode((screen_width, screen_height))

    p_size = 50
    p_x = screen_width // 2 - p_size // 2
    p_y = screen_height // 2 - p_size // 2
    speed = 300
                
    e_size = 50
    e_color = (0, 0, 255)
    enemies = []
    e_speed = 100

    laser_size = 10
    laser_color = (255, 255, 0)
    lasers = []
    laser_speed = 500

    clock = pygame.time.Clock()
    t = time.perf_counter()
    
    while True:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                global running
                running = False
                pygame.quit()
                quit()
            elif event.type == pygame.KEYDOWN and event.key == pygame.K_SPACE:
                laser_x = p_x + p_size // 2 - laser_size // 2
                laser_y = p_y
                lasers.append((laser_x, laser_y))

        if random.random() < 0.01:
            e_x = random.randint(0, screen_width - e_size)
            e_y = -e_size
            enemies.append((e_x, e_y))

        ct = time.perf_counter()
        
        global accx
        global accy
        
        p_x += (accx*speed)
        p_y += (accy*speed)
        
        

        for i, e in enumerate(enemies):
            e_x, e_y = e
            e_y += e_speed * (ct - t)
            enemies[i] = (e_x, e_y)

        enemies = [(e_x, e_y) for e_x, e_y in enemies if e_y < screen_height]

        for i, laser in enumerate(lasers):
            laser_x, laser_y = laser
            laser_y -= laser_speed * (ct - t)
            lasers[i] = (laser_x, laser_y)

        lasers = [(laser_x, laser_y) for laser_x, laser_y in lasers if laser_y > 0]

        for e in enemies:
            e_x, e_y = e
            if (p_x < e_x + e_size and p_x + p_size > e_x and p_y < e_y + e_size and p_y + p_size > e_y):
                running = False
                pygame.quit()
                quit()

        for laser in lasers:
            laser_x, laser_y = laser
            for e in enemies:
                e_x, e_y = e
                if (laser_x < e_x + e_size and laser_x + laser_size > e_x and laser_y < e_y + e_size and laser_y + laser_size > e_y):
                    enemies.remove((e_x, e_y))
                    lasers.remove((laser_x, laser_y))

        screen.fill((0,0,0))
        pygame.draw.rect(screen, (255, 0, 0), (p_x, p_y, p_size, p_size))

        for e in enemies:
            e_x, e_y = e
            pygame.draw.rect(screen, e_color, (e_x, e_y, e_size, e_size))

        for laser in lasers:
            laser_x, laser_y = laser
            pygame.draw.rect(screen, laser_color, (laser_x, laser_y, laser_size, laser_size))

        pygame.display.flip()
        t = ct
        clock.tick(60)


t1 = threading.Thread(target=async_thread)
t2 = threading.Thread(target=my_game)
t1.start()
#t2.start()
time.sleep(5)
running = False
t1.join()
#t2.join()
