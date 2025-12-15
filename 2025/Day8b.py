from math import sqrt, prod

def distance_euclid(x : tuple[int], y : tuple[int]) -> float:
    if len(x) != len(y):
        print("x and y need to be of equal lenght")
        raise ValueError() 
    
    return sqrt(sum([(x[i] - y[i])**2 for i in range(len(x))]))

def add_wire(boxes : set[int], connections : set[set[int]]) -> set[set[int]]:    
    
    overlap = [connection for connection in connections if len(boxes & connection) != 0]
        
    if len(overlap) == 0:
        # If no previous connections, add the two boxes as a new connection
        
        connections.append( boxes )
        return connections

    if len(overlap) == 2:
        # If there are two existing loops, we need to merge them 
        
        connections.remove(overlap[0])
        connections.remove(overlap[1])
        connections.append(overlap[0] | overlap[1] | boxes)

        return connections

    if len(overlap) == 1:
        connection = overlap[0]
            
        if len(boxes & connection) == 1:
            connections.remove(connection)
            connections.append(connection | boxes)

            return connections

        if len(boxes & connection) == 2:

            return connections

    print("There should never be 3 different connections!")
    raise NotImplementedError


test = False

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

while not( len(connections) == 1 and len(connections[0]) == 1000) :
    next_pair = distances.pop(0)
    connections = add_wire(next_pair[1], connections)

indices_last_pair = tuple(next_pair[1])
print( boxes[indices_last_pair[0]][0] * boxes[indices_last_pair[1]][0] )

   