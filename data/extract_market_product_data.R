# ingest text file
text <- here::here("data", "raw_data.txt") |>
  readr::read_delim(
    delim = "\r\n",
    col_names = "option"
  )

# extract data
df <- text |>
	dplyr::mutate(
    outlet_id_pt1 = stringr::str_extract(
      string = option,
      pattern = "(?<=Outlet )[0-9]+?(?= .+? - Item)"
    ),
    outlet_id_pt2 = stringr::str_extract(
      string = option,
      pattern = "(?<=Outlet [0-9]{7} ).+?(?= - Item)"
    ),
    item_id = stringr::str_extract(
      string = option,
      pattern = "(?<=Item )[0-9]{6}(?= - )"
    ),
    item_desc = stringr::str_extract(
      string = option,
      pattern = "(?<=Item [0-9]{6} - ).+"
      # "(?<=Item [])(?=\\.+)(?:\\.+)(\\d+)$"
    ),
    item_desc = stringr::str_replace(
      string = item_desc,
      pattern = "\\.+\\d+$",
      replacement = ""
    ),
    option_code = stringr::str_extract(
      string = option,
      pattern = "(?<=..)\\d+$"
    )
  )