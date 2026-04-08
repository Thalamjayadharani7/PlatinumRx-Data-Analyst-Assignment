def convert_minutes(minutes: int) -> str:
    """
    Convert total minutes into human readable format.
    Example:
        130 -> '2 hrs 10 minutes'
        110 -> '1 hr 50 minutes'
    """
    if minutes < 0:
        return "Invalid input"

    hours, remaining_minutes = divmod(minutes, 60)

    if hours == 0:
        return f"{remaining_minutes} minutes"
    elif hours == 1:
        return f"{hours} hr {remaining_minutes} minutes"
    else:
        return f"{hours} hrs {remaining_minutes} minutes"


# Test cases
print(convert_minutes(130))   # 2 hrs 10 minutes
print(convert_minutes(110))   # 1 hr 50 minutes
print(convert_minutes(45))    # 45 minutes
print(convert_minutes(60))    # 1 hr 0 minutes
print()
