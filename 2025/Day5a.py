with open("2025/Input/Day5.txt") as file_input:
   ranges = [] # list[tuple[int, int]]
   ids    = [] # list[int]

   input_first_part = True

   for line in file_input:
      if line == "\n":
         input_first_part = False
         continue

      if input_first_part is True:
         content = line.split("-")
         ranges.append( (int(content[0]), int(content[1])) )

      else:
         ids.append(int(line))
         

def check_ranges( id : int, ranges : list[tuple[int, int]]) -> list[tuple[int, int]]:
   return [ (lower, upper) for (lower, upper) in ranges if lower <= id <= upper ]
   
count_fresh = 0

for x in ids:
   if len(check_ranges(id = x, ranges = ranges)) > 0:
      count_fresh = count_fresh + 1

print(count_fresh)