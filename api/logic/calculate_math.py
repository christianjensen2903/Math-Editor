

def calculate_math(content: str) -> str:
    """Calculate the result of a math block"""
    return str(eval(content))