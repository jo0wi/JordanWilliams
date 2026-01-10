import time
import pygame 

vs = 5
c = 0.001
r = 2000
i = 0 # initial current
q = 0 # initial charge
vc = 0 #initial capacitor voltage
t = time.perf_counter()

charging = False

width, height = 800, 600
white = (255, 255, 255)
blue = (0, 0, 255)
red = (255, 0, 0)
black = (0, 0, 0)

pygame.init()
screen = pygame.display.set_mode((width, height))

while True:
 for event in pygame.event.get():
  
  if event.type == pygame.QUIT:
   
   pygame.quit()
   quit()

  elif event.type == pygame.KEYDOWN:
   
    if event.key == pygame.K_c:
     charging = True
     t = time.perf_counter()

  elif event.type == pygame.KEYUP:

    if event.key == pygame.K_c:
     charging = False

 if charging:
  
  print(vc)
  t_next = time.perf_counter()
  dt = t_next - t
  t = t_next
  i = (vs - ( q / c ) ) /  r
  q = q + i * dt
  vc += ((i/c) * dt)

 else:
  t_next = time.perf_counter()
  dt = t_next - t
  t = t_next
  q = q + i * dt
  i = -1*(q/c)/r
  vc += ((i/c) *dt)


 screen.fill(black)

 h = height +100
 w = 150 
 left = (width / 2) - 75
 top = (h - 50 - vc * 130)

 pygame.draw.rect(screen, red, (left, top, w, h))
 font = pygame.font.Font('freesansbold.ttf', 32)
 voltage = font.render(f"Voltage: {vc:.2f} v", True , white)
 screen.blit(voltage, (10,10))
 pygame.display.update()
 
