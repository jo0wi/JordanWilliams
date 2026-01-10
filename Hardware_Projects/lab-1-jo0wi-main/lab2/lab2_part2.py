import serial
s = serial.Serial("COM3",115200) 
f = open("reactions.csv","w")
for i in range(10):
    one_line = s.readline().decode().strip()
    f.write(one_line)
    f.write("\n")
    print(one_line)
 
f.close()
s.close()