from pydantic import BaseModel
from enum import Enum
from typing import List, Optional

class BlockType(str, Enum):
    math = "math"
    python = "python"
    markdown = "markdown"

class BlockModel(BaseModel):
    type: BlockType
    content: str
    result: Optional[str] = None
    last_edited: str
    last_calculated: Optional[str] = None