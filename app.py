def average(values):
    if not values:
        return 0

    if not all(isinstance(value, (int, float)) for value in values):
        raise ValueError("All values must be numbers")

    return sum(values) / len(values)
