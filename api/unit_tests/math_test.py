import sys
sys.path.insert(0, '/Users/christianjensen/Library/CloudStorage/OneDrive-UniversityofCopenhagen/2 - Projects/Math Editor/math-editor/api/')

from logic import calculate_math

def test_calculate_math_simple():
    """Test the calculate_math function with a simple math block"""
    assert int(float(calculate_math.calculate_math("1+1"))) == 2

def test_calculate_math_latex():
    """Test the calculate_math function with a simple latex expression"""
    assert int(float(calculate_math.calculate_math(r"\sqrt{4}"))) == 2


def test_solve():
    """Test the solve function with a simple math block"""
    assert calculate_math.calculate_math(r"solve(4x+8)") == '\\left[ -2\\right]'

def test_solve_multiple():
    """Test the solve function with a simple math block with multiple arguments"""
    assert calculate_math.calculate_math(r"solve(4x+8, x)") == '\\left[ -2\\right]'