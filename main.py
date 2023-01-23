from fastapi import FastAPI, File
from fastapi.responses import FileResponse
import json


app = FastAPI()


class StaticApp(FastAPI):
    @app.get("/{file_path:path}")
    async def read_file(file_path: str):
        return FileResponse(f"{file_path}")


@app.get("/json/{faction}/{id}")
async def root(faction: str, id: int):
    f = open(f"json/{id}.json", "r")
    y = json.load(f)
    y["attributes"].append({"value": faction, "trait_type": "Faction"})
    y["image"] = f"http://localhost:8000/image/{id}"

    new_description = "Remilio64 is a collection of Remilio's gone rogue inside the expansion pack of a n64. They have divided up into 10 factions to try and kill each other, and in the end only one faction will remain."

    to_delete = ["Background", "Glasses",
                 "Friend", "Eyes", "Eyebrow", "Mouth", "Earrings", "Hair", "Shirt", "Hat"]

    data = [x for x in y["attributes"] if x["trait_type"] not in to_delete]

    y["attributes"].clear()
    y["attributes"] = data
    y["name"] = f"Remilio64 Rogue #{id}"
    y["description"] = new_description
    return y


@app.get("/image/{id}")
async def image(id: int):
    return FileResponse(f"images/{id}.jpg")


@app.get("/home")
async def home():
    return FileResponse(f"index.html")


app.mount("/v1/static", StaticApp())
