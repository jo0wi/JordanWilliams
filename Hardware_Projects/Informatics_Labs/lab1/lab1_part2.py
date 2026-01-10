R1 = 6
R2 = 10
R3 = 6
R4 = 4
V1 = 10
Req = ((R2+R4)/(R3+R1))
i1 = (V1/Req)
V2 = ((V1)-(i1*R1))
i3 = (V2/R3)
i2 = (i1-i3)
V3 = ((V2) -(i2*R2))
print ('i1 = ' + str(i1),  ' i2 = ' + str(i2),  ' i3 = ' + str(i3))
P1 = ((V1-V2)*i1)
P3 = (V2*i3)
P2 = ((V2 - V3)*i2)
P4 = (V3*i2)
print ('P1 = '+ str(P1), ' P2 = '+ str(P2), ' P3 = '+ str(P3), ' P4 = '+ str(P4))
