import re
from math import prod


rows = []

with open("2025/Input/Day6.txt") as file_input:
    for line in file_input:
        if line.startswith("+") or line.startswith("*"):
            commands = re.split(" +", line.strip())

        else:
            rows.append( [int(x) for x in re.split(" +", line.strip())] )


results = []

for i in range(len(rows[0])):
    if commands[i] == "+":
        results.append(sum([row[i] for row in rows]))
    
    elif commands[i] == "*":
        results.append(prod([row[i] for row in rows]))


print(sum(results))