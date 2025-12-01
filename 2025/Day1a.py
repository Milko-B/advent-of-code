def convert_input_line(line : str) -> int: 
    if line.startswith("R"):
        return int(line[1:])

    if line.startswith("L"):
        return -int(line[1:])
    
    ValueError("Line should start with either 'R' or 'L'")

with open("2025/Input/Day1.txt") as file_input:
    current = 50
    password = 0
    
    for line in file_input:
        new = convert_input_line(line)
        current = (current + new) % 100        
        if current == 0:
            password = password + 1

print(password)


