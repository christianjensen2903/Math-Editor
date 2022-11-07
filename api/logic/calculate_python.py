import re
import GLOBALS
import traceback

def calculate_python(code: str) -> str:
    """Calculate the result of a python block"""

    output = ""

    # print = lambda x: f'{output}\n{x}' # override print function to append to output
    def print(x):
        nonlocal output
        output += str(x) + '\n'

    try:
        for line in code.splitlines():
            # Regex to check for variable assignment
            assignment_re = re.compile(r"^(?P<variable>\w+)\s*=\s*(?P<expression>.+)$")
            match = assignment_re.match(line)
            if match:
                variable = match.group('variable')
                expression = match.group('expression')
                GLOBALS.SAVED_VARIABLES[variable] = eval(expression, GLOBALS.SAVED_VARIABLES)
            else:
                # output += str(eval(line, SAVED_VARIABLES)) + '\n'
                print(eval(line, GLOBALS.SAVED_VARIABLES))
            
    except Exception as e:
        print(traceback.format_exc())

    return output


    


