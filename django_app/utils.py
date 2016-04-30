def prettify_strings(string_list):
    for index, s in enumerate(string_list):
        string_list[index] = s.lower().replace('_', ' ').capitalize()
    return string_list


def _row_names_and_types(description):
    return [el[0] for el in description], [el[1] for el in description]


def _get_row_names(description):
    return prettify_strings([el[0] for el in description])
