from logic import parse
import sympy

def calculate_math(content: str) -> str:
    """Calculate the result of a math block"""
    expression = parse.latex_to_sympy(content)

    return str(expression.evalf())