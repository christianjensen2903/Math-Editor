from fastapi import FastAPI, WebSocket, Request
from fastapi.responses import HTMLResponse, FileResponse
from html import html
from logic import process
from fastapi.staticfiles import StaticFiles


# Get the environment variables
# print(os.getenv("API_URL"))


app = FastAPI()



@app.get("/")
async def get():
    return HTMLResponse(html)


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    while True:
        data = await websocket.receive_text()
        data = data.split(";")
        cell_type = data[0]
        content = data[1]
        json_data = f"""[{{
            "type": "{cell_type}",
            "content": "{content}",
            "result": null,
            "last_edited": "2021-01-01T00:00:00.000000",
            "last_calculated": null
            }}]"""

        await websocket.send_text(process.update(json_data))


@app.get("/images/{image_id}")
async def get_image(image_id: str):
    return FileResponse(f'static/images/{image_id}.png')