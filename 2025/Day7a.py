row_id = 0
splitpoints = {}


with open("2025/Input/Day7.txt") as file_input:
    
    for line in file_input:
        splitpoints[row_id] = set()
        for column_id in range(len(line)):

            if line[column_id] == "S":
                startpoint = (row_id, column_id)
            
            if line[column_id] == "^":
                splitpoints[row_id].add(column_id)

        row_id = row_id + 1


beams = {startpoint[1]}

def propagate_beams(splitpoints_on_level : set[int], beams_incoming : set[int], count = 0) -> set[int]:
    beams = beams_incoming.copy()

    splitpoints_hit = splitpoints_on_level & beams_incoming
    count = count + len(splitpoints_hit)
    
    for x in splitpoints_hit:
        beams.remove(x)
        beams.add(x + 1)
        beams.add(x - 1)
    
    return beams, count

count = 0
for i in range(1, row_id):
    beams, count = propagate_beams(
        splitpoints_on_level = splitpoints[i],
        beams_incoming = beams,
        count = count
    )

print(len(beams))