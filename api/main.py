from fastapi import FastAPI, WebSocket, Request, WebSocketDisconnect
from fastapi.responses import HTMLResponse, FileResponse
from html import html
from logic import process
from typing import List, Dict, Any
from fastapi.middleware.cors import CORSMiddleware
import json
import wordsmiths


app = FastAPI()

origins = ["*"]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


class ConnectionManager:
    def __init__(self):
        self.active_connections: Dict(str, WebSocket) = {}
        self.cursor_positions: Dict(str, int) = {}
        self.content = ""

    async def connect(self, client_id: str, websocket: WebSocket):
        await websocket.accept()
        self.active_connections[client_id] = websocket
        self.cursor_positions[client_id] = 0

    def disconnect(self, client_id: str):
        del self.active_connections[client_id]
        del self.cursor_positions[client_id]
        
    async def broadcast(self, message: str):
        for connection in self.active_connections.values():
            await connection.send_text(message)

    async def emit(self, message: str, client_id: str):
        print(client_id)
        for id, connection in self.active_connections.items():
            if id != client_id:
                await connection.send_text(message)


manager = ConnectionManager()


@app.get("/")
async def get():
    return HTMLResponse(html)


@app.get("/load_notebook")
async def load_notebook():
    print(process.load_notebook())
    return process.load_notebook()


def insert (source_str: str, insert_str: str, pos: int):
    """Inserts a string into a string at a given position"""
    return source_str[:pos]+insert_str+source_str[pos:]

def delete (source_str: str, num_char: int, pos: int):
    """Deletes a n numbers of characters from a string at a given position"""
    left = source_str[:max(pos-num_char,0)] # The current position minus the number of characters to delete
    remaining = num_char - len(left) # The remaining number of characters to delete 
    return left+source_str[pos+remaining:]


def apply_delta(client_id: str, delta: dict[str, List[dict[str, Any]]]):
    """Applies a delta to the content of the notebook"""
    ops = delta["ops"]
    for op in ops:

        cursor_pos = manager.cursor_positions[client_id]
        if "insert" in op:
            manager.content = insert(manager.content, op["insert"], cursor_pos)
        elif "delete" in op:
            manager.content = delete(manager.content, op["delete"],cursor_pos)
        elif "retain" in op:
            manager.cursor_positions[client_id] = op["retain"]
        

    


@app.websocket("/ws/{client_id}")
async def websocket_endpoint(websocket: WebSocket, client_id: str):
    await manager.connect(client_id, websocket)
    try:
        while True:
            data = await websocket.receive_text()
            data = json.loads(data)
            apply_delta(client_id, data)
            await manager.emit(manager.content, client_id)
            # await manager.broadcast(process.update(data))
    except WebSocketDisconnect:
        manager.disconnect(client_id)
        await manager.broadcast(f"Client #{client_id} left the notebook")


@app.get("/images/{image_id}")
async def get_image(image_id: str):
    return FileResponse(f'images/{image_id}.png')