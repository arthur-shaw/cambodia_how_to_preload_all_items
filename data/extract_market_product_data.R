# ingest text file
text <- here::here("data", "raw_data.txt") |>
  readr::read_delim(
    # delimters are line returns
    delim = "\r\n",
    # name the resulting column
    col_names = "option"
  )

# extract data
df <- text |>
	dplyr::mutate(
    # outlet appears to have two parts
    # first part is a 7-digit number
    outlet_id_pt1 = stringr::str_extract(
      string = option,
      pattern = "(?<=Outlet )[0-9]+?(?= .+? - Item)"
    ),
    # second part is sometimes a number, sometimes text
    outlet_id_pt2 = stringr::str_extract(
      string = option,
      pattern = "(?<=Outlet [0-9]{7} ).+?(?= - Item)"
    ),
    # item ID falls between hyphens
    item_id = stringr::str_extract(
      string = option,
      pattern = "(?<=Item )[0-9]{6}(?= - )"
    ),
    # extract the description
    # first, select the part after the item code
    item_desc = stringr::str_extract(
      string = option,
      pattern = "(?<=Item [0-9]{6} - ).+"
    ),
    # then, replace the ending dots and digits with missing
    item_desc = stringr::str_replace(
      string = item_desc,
      pattern = "\\.+\\d+$",
      replacement = ""
    ),
    # option code
    option_code = stringr::str_extract(
      string = option,
      pattern = "(?<=..)\\d+$"
    )
  )