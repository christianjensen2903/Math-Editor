from model.BlockModel import BlockModel
from typing import List
import json

def parse_input(input: str) -> List[BlockModel]:
    """Parse the input json into a list of blocks"""
    blocks = []
    for block in json.loads(input):
        blocks.append(BlockModel(**block))
    return blocks


def parse_output(blocks: List[BlockModel]) -> str:
    """Parse the output json from a list of blocks"""
    return json.dumps([block.dict() for block in blocks])
