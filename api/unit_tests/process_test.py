import sys
sys.path.insert(0, '/Users/christianjensen/Library/CloudStorage/OneDrive-UniversityofCopenhagen/2 - Projects/Math Editor/api/')

from logic import process
import json

def test_process():
    """Test the process function with a simple math block"""
    input = """
    [{
        "type": "math",
        "content": "1+1",
        "result": null,
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": null
    }]
    """
    output = process.update(input)
    assert json.loads(output) == json.loads("""
    [{
        "type": "math",
        "content": "1+1",
        "result": "2",
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": "2021-01-01T00:00:00.000000"
    }]
    """)


def test_process_multiple():
    """Test the process function with multiple blocks"""
    input = """
    [{
        "type": "math",
        "content": "1+1",
        "result": null,
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": null
    },
    {
        "type": "math",
        "content": "1+1",
        "result": null,
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": null
    }]
    """
    output = process.update(input)
    assert json.loads(output) == json.loads("""
    [{
        "type": "math",
        "content": "1+1",
        "result": "2",
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": "2021-01-01T00:00:00.000000"
    },
    {
        "type": "math",
        "content": "1+1",
        "result": "2",
        "last_edited": "2021-01-01T00:00:00.000000",
        "last_calculated": "2021-01-01T00:00:00.000000"
    }]
    """)