from math import sqrt, prod

def distance_euclid(x : tuple[int], y : tuple[int]) -> float:
    if len(x) != len(y):
        print("x and y need to be of equal lenght")
        raise ValueError() 
    
    return sqrt(sum([(x[i] - y[i])**2 for i in range(len(x))]))

def add_wire(boxes : set[int], connections : list[set[int]]) -> tuple[list[set[int]], bool]:    
    connections_changed = True

    connected = [connection for connection in connections if len(boxes & connection) != 0]

    for connection in connections:
        if len(boxes & connection) == 1:
            connections.remove(connection)
            connections.append(connection | boxes)
            
            return connections, connections_changed
        
        if len(boxes & connection) == 2:
            return connections, not connections_changed

    # If no previous connections, add the two boxes as a new connection
    connections.append( boxes )
    return connections, connections_changed

test = True

if test:
    filename =  "2025/Input/Day8Test.txt"
else:
    filename = "2025/Input/Day8.txt"

with open(filename) as input_file:
    boxes = []

    for line in input_file:
        boxes.append(  tuple( int(x) for x in line.split(",") ) )

distances = [
    tuple( [distance_euclid(boxes[i], boxes[j]), {i, j}] )
    for i in range(0, len(boxes))
    for j in range(i + 1, len(boxes))
]
distances.sort()

connections = []

for i in range(10):
    print(f"Adding cable {i + 1}")
    new_link   = False
    while new_link is False:
        next_pair = distances.pop(0)
        print(f"{next_pair[1]}")
        connections, new_link = add_wire(next_pair[1], connections)
        if new_link:
            print(f"{connections}")
    continue

lengths = [len(connection) for connection in connections]
lengths.sort()
print( prod(lengths[-3:]))