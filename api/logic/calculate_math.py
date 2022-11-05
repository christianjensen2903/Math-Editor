import sympy
import latex2sympy2
import re


regexes = {
    'solve': re.compile(r"^solve\((.*?)(,(.*))?\)$"),
    'simplify': re.compile(r"^simplify\((.+)\)$"),
}


def calculate_math(expression: str) -> str:
    """Calculate the result of a math expression"""

    expression = calculate_helper(expression)

    return sympy_to_latex(expression)


def calculate_helper(expression: str) -> str:
    """Helper function for calculating math expressions
    Maps custom functions to sympy functions recursively"""

    if regexes['solve'].match(expression):
        expression = solve(expression)
    elif regexes['simplify'].match(expression):
        expression = simplify(expression)
    else: 
        expression = latex_to_sympy(expression).doit()

    return expression


def simplify(expression: str) -> str:
    """Simplify an expression"""
    match = regexes['simplify'].match(expression)
    expression = match.group(1)
    expression = calculate_helper(expression)
    expression = sympy.simplify(expression)
    return expression


def solve(expression: str) -> str:
    """Solve an expression"""
    match = regexes['solve'].match(expression)
    expression = match.group(1)
    expression = calculate_helper(expression)

    if match.groups()[2] is not None: # If the expression contains a second argument
        variable = match.group(3)
        expression = sympy.solve(expression, variable)
    else:
        expression = sympy.solve(expression)

    return expression


def latex_to_sympy(latex: str) -> str:
    """Convert latex to sympy"""

    # If the latex contains an equal sign subtract the left side from the right side
    if latex.find('=') != -1: 
        latex = latex.replace('=', '-(') + ')'

    return latex2sympy2.latex2sympy(latex)


def sympy_to_latex(expression: str) -> str:
    """Convert sympy to latex"""
    return sympy.latex(expression)



