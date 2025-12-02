def is_sequence(check : str) -> bool:
    if len(check) == 1:
        return False 
    
    for n in range(1, len(check) // 2 + 1):
        n_translation = check[n:] + check[:n]
        if n_translation == check:
            return True
    
    return False

def read_spread(line : str) -> tuple[int, int]:
    split = line.split("-")

    return int(split[0]), int(split[1])

def collect_false_id(start : int, end: int) -> list[int]:
    false_ids = []
    
    for id in range(start, end + 1):
        if is_sequence(str(id)):
            false_ids.append(id)
    
    return false_ids

with open("2025/Input/Day2.txt") as file_input:
    false_ids = []
    for line in file_input:
        spreads = [read_spread(text) for text in line.split(",")]

        for spead in spreads:
            false_ids = false_ids + collect_false_id(start = spead[0], end = spead[1])
        
print(sum(false_ids))