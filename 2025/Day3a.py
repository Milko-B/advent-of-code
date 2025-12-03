def find_highest_joltage(row : list[int]) -> int:
    battery_1 = 0 
    battery_2 = 0

    row_size = len(row)

    for index, value in enumerate(row):        
        if battery_1 < value and index != row_size - 1:
            battery_1 = value
            battery_2 = 0
            continue
        
        if battery_2 < value:
            battery_2 = value
        
    return battery_1 * 10 + battery_2

def convert_string_to_battery_joltage(input : str) -> list[int]:
    return [int(x) for x in input]


with open("2025/Input/Day3.txt") as input_file:
    joltages = []

    for line in input_file:
        battery_row = convert_string_to_battery_joltage(line.strip())

        joltages.append(find_highest_joltage(battery_row))
    
print(sum(joltages))