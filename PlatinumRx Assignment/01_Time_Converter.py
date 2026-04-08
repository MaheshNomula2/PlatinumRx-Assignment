"""
PlatinumRx Assignment | Python Proficiency
File: 01_Time_Converter.py
Goal: Convert a given number of minutes into a human-readable string.
      e.g. 130  ->  "2 hrs 10 minutes"
           110  ->  "1 hr 50 minutes"
           60   ->  "1 hr 0 minutes"
           45   ->  "0 hrs 45 minutes"
"""


def convert_minutes(total_minutes: int) -> str:
    """
    Convert integer minutes to 'X hr(s) Y minutes' format.

    Parameters
    ----------
    total_minutes : int
        Non-negative number of minutes to convert.

    Returns
    -------
    str
        Human-readable duration string.
    """
    if not isinstance(total_minutes, (int, float)) or total_minutes < 0:
        return "Please provide a non-negative number."

    total_minutes = int(total_minutes)

    hours           = total_minutes // 60      # integer division gives whole hours
    remaining_mins  = total_minutes  % 60      # modulo gives leftover minutes

    # Pluralise "hr" / "hrs" for readability
    hour_label = "hr" if hours == 1 else "hrs"

    return f"{hours} {hour_label} {remaining_mins} minutes"


# ---------------------------------------------------------------------------
# Test cases
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    test_inputs = [130, 110, 60, 45, 0, 1, 61, 500, 1440]

    print("Minutes  →  Human-readable")
    print("-" * 35)
    for mins in test_inputs:
        print(f"{mins:>7}  →  {convert_minutes(mins)}")
