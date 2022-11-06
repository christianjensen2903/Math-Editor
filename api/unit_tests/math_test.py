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
    assert calculate_math.calculate_math(r"solve(4x+8)") == '-2'

def test_solve_multiple():
    """Test the solve function with a simple math block with multiple arguments"""
    assert calculate_math.calculate_math(r"solve(4x+8, x)") == '-2'

def test_solve_multiple_2():
    """Test the solve function with a simple math block with multiple arguments"""
    assert calculate_math.calculate_math(r"solve(4x+8, y)") == '\\left[ \\right]'

def test_simplify():
    """Test the simplify function with a simple math block"""
    assert calculate_math.calculate_math(r"simplify(2x+3x)") == '5 x'

def test_expand():
    """Test the expand function with a simple math block"""
    assert calculate_math.calculate_math(r"expand((x+1)^2)") == r'x^{2} + 2 x + 1'

def test_factor():
    """Test the factor function with a simple math block"""
    assert calculate_math.calculate_math(r"factor(x^2+2x+1)") == '\\left(x + 1\\right)^{2}'


def test_is_equal():
    """Test the is_equal function with a simple math block"""
    assert calculate_math.calculate_math(r"is_equal(2x+3x, 5x)") == '\\text{True}'

def test_is_equal_false():
    """Test the is_equal function with a simple math block"""
    assert calculate_math.calculate_math(r"is_equal(2x+3x, 6x)") == '\\text{False}'


def test_solve_assignment():
    """Test the that assignemt of variables works for solve"""
    assert calculate_math.calculate_math(r"solve(2x+3y=5x, x)") == 'y'