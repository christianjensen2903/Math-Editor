from typing import Dict, Any
import os
from dotenv import load_dotenv


load_dotenv()

SAVED_VARIABLES: Dict[str, Any] = {
}


API_URL = os.environ.get('API_URL')

