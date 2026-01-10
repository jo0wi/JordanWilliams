import matplotlib.pyplot as plt
import csv
import numpy 
react_time = []
trial = []
i = 0
f = open("reactions.csv","r")
for row in f:
    react_time.append(row.split(",")[0])
    trial.append(i) 
    i+=1
f.close()
print(react_time)
print(trial)
plt.bar(trial , react_time)
plt.title('Average Reaction Time for Valid Trials')
plt.xlabel('Trial')
plt.ylabel('Reaction Time')
plt.savefig("reactions.png")
plt.show()