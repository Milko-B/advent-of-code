with open("2025/Input/Day5.txt") as file_input:
   ranges = [] # list[tuple[int, int]]

   for line in file_input:
      if line == "\n":
         break

      content = line.split("-")
      ranges.append( (int(content[0]), int(content[1])) )
   
   ranges.sort()
   

def reduce_intervals(
      unreduced : list[tuple[int, int]],
      reduced   : list[tuple[int, int]]  = []
   ) -> list[tuple[int, int]]:
   """
   This function will only work if you start with unreduced being already sorted
   This ensures that the next interval always starts with a limit bigger than or equal to the on in reduced.
   """
   if len(unreduced) == 0:
      return reduced

   if len(reduced) == 0:
      return reduce_intervals(unreduced[1:], reduced = unreduced[0:1])

   (lower_ref, upper_ref) = reduced[-1]
   (lower_new, upper_new) = unreduced[0]

   if lower_new <= upper_ref:
      if upper_ref < upper_new:
         # Update the upper bound
         reduced[-1] = (lower_ref, upper_new)

         return reduce_intervals(
            unreduced = unreduced[1:],
            reduced = reduced
         )
         
      else: 
         return reduce_intervals(
            unreduced = unreduced[1:],
            reduced = reduced
         )

   else:
      return reduce_intervals(
         unreduced = unreduced[1:],
         reduced = reduced + unreduced[0:1]
      )

ranges_reduced = reduce_intervals(ranges)

print( sum([ upper - lower + 1 for (lower, upper) in ranges_reduced ]) )