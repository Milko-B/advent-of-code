def convert_input_line(line : str) -> int: 
    if line.startswith("R"):
        return int(line[1:])

    if line.startswith("L"):
        return -int(line[1:])
    
    ValueError("Line should start with either 'R' or 'L'")

with open("2025/Input/Day1.txt") as file_input:
    current_value = 50
    password = 0
    
    for line in file_input:
        new = convert_input_line(line)

        new_value = current_value + new
        
        if new_value < 0 and current_value != 0:
            # - 50 // 100 yields -1 so taking the absolute value nicely counts how many times we have passed 0.  
            password = password + abs(new_value // 100)
            # - 100 // 100 yields -1, but we have passed 0 once more so we need to account for this
            # This does not cause problems in a positive rotation
            if new_value % 100 == 0:
                password = password + 1
        
        elif new_value < 0 and current_value == 0:
            # if we started at 0, we did not pass it when turning to the left
            password = password + abs(new_value // 100) - 1
            if new_value % 100 == 0:
                password = password + 1

        elif new_value == 0:
            password = password + 1

        else:
            password = password + (new_value // 100)

        current_value  = new_value % 100 

print(password)