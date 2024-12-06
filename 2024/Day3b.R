library(tidyverse)

input <- read.delim("./Input/InputDay3.txt", header = FALSE,)[,1] |> stringr::str_flatten(collapse = "")

operations <- stringr::str_extract_all(
  string = input,
  pattern = "mul\\([:digit:]{1,3},[:digit:]{1,3}\\)|do\\(\\)|don't\\(\\)"
) |> list_c()

allowed_muls <- tibble(
    operations = operations
  ) |> 
  mutate(
    use = case_when(
      operations == "do()" ~ TRUE,
      operations == "don't()" ~ FALSE,
      TRUE ~ NA
    )
  ) |> 
  tidyr::fill(use, .direction = "down") |> 
  tidyr::replace_na(list(use = TRUE)) |> 
  filter(
    use & operations != "do()"
  ) |> 
  pluck("operations")

allowed_muls |> 
  purrr::map(
    .f = \(string) stringr::str_extract(string, "[:digit:]{1,3},[:digit:]{1,3}") |> stringr::str_split(pattern = ",")
  ) |> 
  purrr::list_flatten() |> 
  purrr::map(
    .f = \(values)  mul(values[1], values[2])
  ) |> 
  purrr::list_c() |> 
  sum()

