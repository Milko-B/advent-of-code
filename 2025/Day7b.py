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


paths = {startpoint[1] : 1}

def propagate_beams(
    splitpoints_on_level : set[int],
    paths_incoming : dict[int, int]
) -> dict[int, int]:
    
    paths_outgoing = paths_incoming.copy()
    
    beams = set( paths_incoming.keys() )

    splitpoints_hit = splitpoints_on_level & beams
    
    for split in splitpoints_hit:
        n_split = paths_outgoing.pop(split)

        if split + 1 in paths_outgoing.keys():
            paths_outgoing[split + 1] = paths_outgoing[split + 1] + n_split
        else:
            paths_outgoing[split + 1] = n_split
    
        if split - 1 in paths_outgoing.keys():
            paths_outgoing[split - 1] = paths_outgoing[split - 1] + n_split
        else:
            paths_outgoing[split - 1] = n_split
    
    
    return paths_outgoing

for i in range(1, row_id):
    paths = propagate_beams(
        splitpoints_on_level = splitpoints[i],
        paths_incoming = paths
    )

print(sum(paths.values()))