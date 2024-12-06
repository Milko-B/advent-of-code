input <- read.delim("./Input/InputDay3.txt", header = FALSE,)[,1] |> stringr::str_flatten(collapse = "")
mul <- function(x,y){
  x <- as.numeric(x)
  y <- as.numeric(y)
  
  x*y
}

mul_operations <- stringr::str_extract_all(
    string = input,
    pattern = "mul\\([:digit:]{1,3},[:digit:]{1,3}\\)"
  )

mul_operations |> 
  purrr::map(
    .f = \(string) stringr::str_extract(string, "[:digit:]{1,3},[:digit:]{1,3}") |> stringr::str_split(pattern = ",")
  ) |> 
  purrr::list_flatten() |> 
  purrr::map(
    .f = \(values)  mul(values[1], values[2])
  ) |> 
  purrr::list_c() |> 
  sum()
