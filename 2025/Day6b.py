from re import split
from math import prod

rows = []

with open("2025/Input/Day6.txt") as file_input:
    for line in file_input:
        if line.startswith("+") or line.startswith("*"):
            commands = split(" +", line.strip())

        else:
            rows.append( line.strip().replace(" ", ".") )

def extract_columns(rows : list[str]) -> list[list[str]]:
    # Only works if all strings in the input have the same length
     
    inputs = []

    begin_index = 0

    for i in range( len(rows[0]) ):
        if all( row[i] == "." for row in rows):
            inputs.append( [row[begin_index: i] for row in rows] )
            begin_index = i + 1
            continue
        
        if i == len(rows[0]) - 1:
            inputs.append( [row[begin_index:] for row in rows] )

    return inputs

raw_columns = extract_columns(rows)

def parse_column( raw_column : list[str] ) -> list[int]:
    size_column = len(raw_column[0])
    raw_column = [ x[::-1] for x in raw_column]

    parsed_column = []

    for i in range(size_column):
        digits =  [x[i] for x in raw_column if x[i] != "."]   
        parsed_column.append(sum([ int(digits[i]) * 10**(len(digits) - 1 - i) for i in range(len(digits))]))
        
    return parsed_column

parsed_columns = [parse_column(raw) for raw in raw_columns]

results = []
for i in range(len(parsed_columns)):
    if commands[i] == "+":
        results.append(sum(parsed_columns[i]))
    
    elif commands[i] == "*":
        results.append(prod(parsed_columns[i]))

print(sum(results))