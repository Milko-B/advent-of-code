def convert_string_to_battery_joltage(input : str) -> list[int]:
    return [int(x) for x in input]

def convert_active_batteries_to_int(active : list[int]) -> int:
    return sum( [10 ** (len(active) - 1 - index) * x for index, x in enumerate(active)] )


def find_highest_joltage(
        row : list[int],
        n_batteries : int,
        active_batteries: list[int] = []
    ) -> int:
    
    # Stop Condition
    if n_batteries == 0:
        return active_batteries

    if n_batteries > len(row):
        raise ValueError(f"The number of batteries {n_batteries} is higher than the available number of batteries {len(row)}")

    if n_batteries == 1:
        # [0:-0] causes [] which  is not what we want
        searchspace = row
    else:
        searchspace = row[0: - (n_batteries - 1)]

    next_battery = 0
    next_battery_index = 0

    for index, value in enumerate(searchspace):
        if next_battery < value:
            next_battery = value
            next_battery_index = index


    return find_highest_joltage(
        row = row[next_battery_index + 1:],
        n_batteries = n_batteries - 1,
        active_batteries = active_batteries + [next_battery] 
    )

with open("2025/Input/Day3.txt") as input_file:
    joltages = []

    for line in input_file:
        battery_row = convert_string_to_battery_joltage(line.strip())

        joltages.append(
            convert_active_batteries_to_int(
                find_highest_joltage(row = battery_row, n_batteries = 12, active_batteries = [])
            )
        )
    
print(sum(joltages))