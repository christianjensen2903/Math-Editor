import sys
sys.path.insert(0, '/Users/christianjensen/Library/CloudStorage/OneDrive-UniversityofCopenhagen/2 - Projects/Math Editor/math-editor/api/')

from logic import calculate_python, calculate_markdown


def test_calculate_python():
    """Test the calculate_python function with a simple python block"""
    assert int(calculate_python.calculate_python("1+1")) == 2

def test_calculate_markdown():
    """Test the calculate_markdown function with a simple markdown block"""
    assert calculate_markdown.calculate_markdown("Hello World") == "Hello World"