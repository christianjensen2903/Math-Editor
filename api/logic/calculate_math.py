import sympy
import latex2sympy2
import re
import GLOBALS
import uuid
from fastapi import Request


# TODO: Use SAVED_VARIABLES to store variables and calculate them
# TODO: if constant (no free_variables) save the evaluated expression
# TODO: Plot both 2D and 3D
# TODO: Plot both f(x)=.., x=.. and x/y=.. (maybe use solve if = is in the expression)
# TODO: Add names to regex groups


regexes = {
    'solve': re.compile(r"^solve\((.*?)(,(.*))?\)$"),
    'simplify': re.compile(r"^simplify\((.+)\)$"),
    'expand': re.compile(r"^expand\((.+)\)$"),
    'factor': re.compile(r"^factor\((.+)\)$"),
    'is_equal': re.compile(r"^is_equal\((.+),(.+)\)$"),
    'define': re.compile(r"^(.+?)(\((.+)\))?:=(.*)$"),
    'plot': re.compile(r"^plot\((?P<expression>(?P<left_expression>.+?)(=(?P<right_expression>.+))?)\)$")
}


def calculate_math(expression: str) -> str:
    """Calculate the result of a math expression"""

    # Top level functions
    if regexes['plot'].match(expression):
        return plot(expression)
    else: # functions to be called recursively
        expression = calculate_helper(expression)

    return sympy_to_latex(expression)


def calculate_helper(expression: str) -> str:
    """Helper function for calculating math expressions
    Maps custom functions to sympy functions recursively"""

    if regexes['solve'].match(expression):
        expression = solve(expression)
    elif regexes['simplify'].match(expression):
        expression = simplify(expression)
    elif regexes['expand'].match(expression):
        expression = expand(expression)
    elif regexes['factor'].match(expression):
        expression = factor(expression)
    elif regexes['is_equal'].match(expression):
        expression = is_equal(expression)
    elif regexes['define'].match(expression):
        expression = define(expression)
    else: 
        expression = latex_to_sympy(expression)

    return expression


# TODO: Fix disconnection of websocket when adding image
def plot(expression: str) -> str:
    """Plot an expression"""
    # Regex = left_expression = right_expression

    match = regexes['plot'].match(expression)
    expression = match.group('expression') # whole expression
    left_expression = match.group('left_expression') # left side of equal sign
    right_expression = match.group('right_expression') # right side of equal sign

    if right_expression: # there is an equal sign
        left_expression = latex_to_sympy(left_expression)
        if len(left_expression.free_symbols) > 1: # more than one variable on left side solve for one of them
            expression = sympy.solve(latex_to_sympy(expression))
        elif len(left_expression.free_symbols) == 1: # one variable on left side plot the right side
            expression = latex_to_sympy(right_expression)
        else: # no variables on left side plot the right side solve expression and plot
            expression = sympy.solve(latex_to_sympy(expression))
    else: # no equal sign
        expression = latex_to_sympy(expression)

    image_id = str(uuid.uuid4())
    
    if isinstance(expression, list): # expression is a list of solutions
        sympy.plot(expression[0], show=False).save(f'images/{image_id}.png')
    else:
        if len(expression.free_symbols) == 2: # 3D plot
            sympy.plotting.plot3d(expression, show=False).save(f'images/{image_id}.png')
        else: # 2D plot
            sympy.plot(expression, show=False).save(f'images/{image_id}.png')

    # return static file as latex image
    return f"""
    \\begin{{figure}}[h]
        \\centering
        \\includegraphics[width=0.5\\textwidth]{GLOBALS.API_URL + '/images/' + image_id + '.png'}
    \\end{{figure}}
    """
    

    

    


def define(expression: str) -> str:
    """Assign an expression to a variable"""
    match = regexes['define'].match(expression)
    variable = match.group(1)
    arguments = match.group(3)
    expression = match.group(4)
    expression = calculate_helper(expression)
    
    if arguments is None:
        GLOBALS.SAVED_VARIABLES[variable] = sympy.lambdify(expression.free_symbols, expression)
        return f'{variable} = {expression}'
    else:
        GLOBALS.SAVED_VARIABLES[variable] = sympy.lambdify(sympy.symbols(arguments), expression)
        return f'{variable}({arguments}) = {expression}'


def is_equal(expression: str) -> str:
    """Check if two expressions are equal"""
    match = regexes['is_equal'].match(expression)
    expression1 = match.group(1)
    expression2 = match.group(2)
    expression1 = calculate_helper(expression1)
    expression2 = calculate_helper(expression2)
    result = sympy.simplify(f'{expression1} - {expression2}') # Simplify the difference of the two expressions
    return result == 0

def factor(expression: str) -> str:
    """Factor an expression"""
    match = regexes['factor'].match(expression)
    expression = match.group(1)
    expression = calculate_helper(expression)
    expression = sympy.factor(expression)
    return expression


def expand(expression: str) -> str:
    """Expand an expression"""
    match = regexes['expand'].match(expression)
    expression = match.group(1)
    expression = calculate_helper(expression)
    expression = sympy.expand(expression)
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
        if len(expression) == 1: # If there is only one solution unpack it
            expression = expression[0]
            # save the solution to the variable
            GLOBALS.SAVED_VARIABLES[variable] = sympy.lambdify(expression.free_symbols, expression)
        else:
            GLOBALS.SAVED_VARIABLES[variable] = [sympy.lambdify(expr.free_symbols, expr) for expr in expression]
    else:
        expression = sympy.solve(expression)

        if len(expression) == 1: # If there is only one solution unpack it
            expression = expression[0]

    return expression


def latex_to_sympy(latex: str) -> str:
    """Convert latex to sympy"""

    # If the latex contains an equal sign subtract the left side from the right side
    if latex.find('=') != -1: 
        latex = latex.replace('=', '-(') + ')'

    return latex2sympy2.latex2sympy(latex).doit()


def sympy_to_latex(expression: str) -> str:
    """Convert sympy to latex"""
    return sympy.latex(expression)



