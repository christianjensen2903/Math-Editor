from pydantic import BaseModel
from typing import List
from model.BlockModel import BlockModel


class NotebookModel(BaseModel):
    title: str
    blocks: List[BlockModel]
    running: bool = False