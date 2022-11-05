import sys
sys.path.insert(0, '/Users/christianjensen/Library/CloudStorage/OneDrive-UniversityofCopenhagen/2 - Projects/Math Editor/math-editor/api/')

from logic import parse
from model.BlockModel import BlockModel

def test_parse_input_math_simple():
    """Test the parse_input function with a simple math block"""
    input = """
    [{
        "type": "math",
        "content": "1+1",
        "result": null,
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": null
    }]
    """
    blocks = parse.parse_input(input)
    assert len(blocks) == 1
    assert blocks[0].type == "math"
    assert blocks[0].content == "1+1"
    assert blocks[0].result == None
    assert blocks[0].last_edited == "2021-01-01T00:00:00.000000"
    assert blocks[0].last_calculated == None

def test_parse_input_math_latex():
    """Test the parse_input function with a simple latex expression"""
    input = r"""
    [{
        "type": "math",
        "content": "\\sqrt{4}",
        "last_edited": "2021-01-01T00:00:00.000000",
        "result": null,
        "last_calculated": null
    }]
    """
    blocks = parse.parse_input(input)
    assert len(blocks) == 1
    assert blocks[0].type == "math"
    assert blocks[0].content == r"\sqrt{4}"
    assert blocks[0].result == None
    assert blocks[0].last_edited == "2021-01-01T00:00:00.000000"
    assert blocks[0].last_calculated == None


def test_parse_input_python():
    """Test the parse_input function with a simple python block"""
    input = """
    [{
        "type": "python",
        "content": "1+1",
        "result": null,
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": null
    }]
    """
    blocks = parse.parse_input(input)
    assert len(blocks) == 1
    assert blocks[0].type == "python"
    assert blocks[0].content == "1+1"
    assert blocks[0].result == None
    assert blocks[0].last_edited == "2021-01-01T00:00:00.000000"
    assert blocks[0].last_calculated == None


def test_parse_input_markdown():
    """Test the parse_input function with a simple markdown block"""
    input = """
    [{
        "type": "markdown",
        "content": "test",
        "result": null,
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": null
    }]
    """
    blocks = parse.parse_input(input)
    assert len(blocks) == 1
    assert blocks[0].type == "markdown"
    assert blocks[0].content == "test"
    assert blocks[0].result == None
    assert blocks[0].last_edited == "2021-01-01T00:00:00.000000"
    assert blocks[0].last_calculated == None


def test_parse_input_multiple():
    """Test the parse_input function with multiple blocks"""
    input = """
    [{
        "type": "markdown",
        "content": "test",
        "result": null,
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": null
    },
    {
        "type": "markdown",
        "content": "test",
        "result": null,
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": null
    }]
    """
    blocks = parse.parse_input(input)
    assert len(blocks) == 2
    assert blocks[0].type == "markdown"
    assert blocks[0].content == "test"
    assert blocks[0].result == None
    assert blocks[0].last_edited == "2021-01-01T00:00:00.000000"
    assert blocks[1].type == "markdown"
    assert blocks[1].content == "test"
    assert blocks[1].result == None
    assert blocks[1].last_edited == "2021-01-01T00:00:00.000000"



def test_parse_output_math_simple():
    """Test the parse_output function with a simple math block"""
    blocks = [
        BlockModel(type="math", content="1+1", result=None, last_edited="2021-01-01T00:00:00.000000", last_calculated=None)
    ]
    output = parse.parse_output(blocks)
    assert output == '[{"type": "math", "content": "1+1", "result": null, "last_edited": "2021-01-01T00:00:00.000000", "last_calculated": null}]'

def test_parse_output_math_latex():
    """Test the parse_output function with a simple latex expression"""
    blocks = [
        BlockModel(type="math", content=r"\sqrt{4}", result=None, last_edited="2021-01-01T00:00:00.000000", last_calculated=None)
    ]
    output = parse.parse_output(blocks)
    assert output == r'[{"type": "math", "content": "\\sqrt{4}", "result": null, "last_edited": "2021-01-01T00:00:00.000000", "last_calculated": null}]'

def test_parse_output_python():
    """Test the parse_output function with a simple python block"""
    blocks = [
        BlockModel(type="python", content="1+1", result=None, last_edited="2021-01-01T00:00:00.000000", last_calculated=None)
    ]
    output = parse.parse_output(blocks)
    assert output == '[{"type": "python", "content": "1+1", "result": null, "last_edited": "2021-01-01T00:00:00.000000", "last_calculated": null}]'

def test_parse_output_markdown():
    """Test the parse_output function with a simple markdown block"""
    blocks = [
        BlockModel(type="markdown", content="test", result=None, last_edited="2021-01-01T00:00:00.000000", last_calculated=None)
    ]
    output = parse.parse_output(blocks)
    assert output == '[{"type": "markdown", "content": "test", "result": null, "last_edited": "2021-01-01T00:00:00.000000", "last_calculated": null}]'

def test_parse_output_multiple():
    """Test the parse_output function with multiple blocks"""
    blocks = [
        BlockModel(type="markdown", content="test", result=None, last_edited="2021-01-01T00:00:00.000000", last_calculated=None),
        BlockModel(type="markdown", content="test", result=None, last_edited="2021-01-01T00:00:00.000000", last_calculated=None)
    ]
    output = parse.parse_output(blocks)
    assert output == '[{"type": "markdown", "content": "test", "result": null, "last_edited": "2021-01-01T00:00:00.000000", "last_calculated": null}, {"type": "markdown", "content": "test", "result": null, "last_edited": "2021-01-01T00:00:00.000000", "last_calculated": null}]'