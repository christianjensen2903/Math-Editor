from fastapi import FastAPI, WebSocket
from fastapi.responses import HTMLResponse
from html import html
from logic import process


app = FastAPI()


@app.get("/")
async def get():
    return HTMLResponse(html)


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        json_data = f"""[{{
            "type": "math",
            "content": "{data}",
            "result": null,
            "last_edited": "2021-01-01T00:00:00.000000",
            "last_calculated": null
            }}]"""

        await websocket.send_text(process.update(json_data))
        
        # await websocket.send_text(f"Message text was: {data}")