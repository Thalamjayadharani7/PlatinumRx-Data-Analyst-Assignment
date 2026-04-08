def remove_duplicates(s: str) -> str:
    """
    Remove duplicate characters from a string
    while preserving original order.
    Example:
        'programming' -> 'progamin'
    """
    seen = set()
    result = []

    for char in s:
        if char not in seen:
            seen.add(char)
            result.append(char)

    return "".join(result)


# Test cases
print(remove_duplicates("programming"))   # progamin
print(remove_duplicates("platinumrx"))    # platinumrx
print(remove_duplicates("aabbccdd"))      # abcd
