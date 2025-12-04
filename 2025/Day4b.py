def find_neighbours(
    grid    : list[list[str]],
    x0      : int,
    x_max   : int,
    y0      : int,
    y_max   : int
) -> list[str]:
    possible_neighbours = [
        (y0 + y, x0 + x)
            for y in [-1, 0, 1] if 0 <= y0 + y < y_max
            for x in [-1, 0, 1] if 0 <= x0 + x < x_max
    ]
    possible_neighbours.remove((y0, x0))
        
    return [ grid[y][x] for (y, x) in possible_neighbours ]




with open("2025/Input/Day4.txt") as file_input:
    grid = []

    for line in file_input:
        grid.append( list(line.strip()))

x_max = len(grid[0])
y_max = len(grid)
count = 0
count_previous = -1

while count != count_previous:
    count_previous = count
    for y0 in range(y_max):
        for x0 in range(x_max):
            if grid[y0][x0] == ".":
                pass

            else:
                neighbours = find_neighbours(
                        grid,
                        x0 = x0,
                        x_max = x_max,
                        y0 = y0,
                        y_max = y_max
                    )
                
                if len([roll for roll in neighbours if roll == "@"]) < 4:
                    count = count + 1
                    grid[y0][x0] = "."

print(count)
