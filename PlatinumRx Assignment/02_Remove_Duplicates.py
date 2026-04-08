"""
PlatinumRx Assignment | Python Proficiency
File: 02_Remove_Duplicates.py
Goal: Given a string, remove duplicate characters using a loop
      and print the unique string (preserving first occurrence order).
      e.g. "programming"  ->  "progamin"
           "aabbcc"       ->  "abc"
           "Hello World"  ->  "Helo Wrd"
"""


def remove_duplicates(input_string: str) -> str:
    """
    Remove duplicate characters from a string using an explicit loop.
    The first occurrence of every character is kept; subsequent ones are dropped.

    Parameters
    ----------
    input_string : str
        The string to process.

    Returns
    -------
    str
        String with duplicate characters removed.
    """
    result = ""                          # start with an empty result

    for char in input_string:           # iterate over every character
        if char not in result:          # only add if NOT already present
            result += char              # append unique character

    return result


# ---------------------------------------------------------------------------
# Test cases
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    test_strings = [
        "programming",
        "aabbcc",
        "Hello World",
        "mississippi",
        "abcabc",
        "12321",
        "",                            # edge case: empty string
        "aaaa",                        # edge case: all same character
        "abcdefg",                     # edge case: already unique
    ]

    print(f"{'Input':<20}  →  {'Unique Output'}")
    print("-" * 45)
    for s in test_strings:
        print(f"{repr(s):<20}  →  {repr(remove_duplicates(s))}")
