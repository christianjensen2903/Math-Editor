# from ..model.BlockModel import BlockModel
# from ..model.BlockModel import BlockType
from model.BlockModel import BlockModel
from model.BlockModel import BlockType
from model.NotebookModel import NotebookModel
from logic.calculate_markdown import calculate_markdown
from logic.calculate_math import calculate_math
from logic.calculate_python import calculate_python
from logic import parse
from typing import List




def process_block(block: BlockModel) -> BlockModel:
    """Process a block"""
    # If the block haven't been edited since last calculation do nothing
    if block.last_calculated == block.last_ran:
        return block

    # Calculate the result of the block
    if block.type == BlockType.math:
        block.result = calculate_math(block.content)
    elif block.type == BlockType.python:
        block.result = calculate_python(block.content)
    elif block.type == BlockType.markdown:
        block.result = calculate_markdown(block.content)

    # Update the last calculated time
    block.last_calculated = block.last_ran

    return block


def update(input: str) -> str:
    """Update the input json with the results of the calculations"""
    blocks = parse.parse_input(input)
    blocks = [process_block(block) for block in blocks]
    return parse.parse_output(blocks)




example_notebook = NotebookModel(
    title="Example Notebook",
    blocks=[
        BlockModel(
            type=BlockType.math,
            content="1+1",
            last_ran=None,
            last_calculated=None,
            result=None,
        ),
    ]
)

def load_notebook() -> str:
    """Load the example notebook"""
    return parse.parse_output(example_notebook.blocks)
