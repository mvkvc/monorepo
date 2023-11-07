from contextlib import asynccontextmanager
import uvicorn
from fastapi import FastAPI
from fastapi.responses import StreamingResponse
from pyvirtualdisplay import Display
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from PIL import Image
import io

SCREEN_X = 600
SCREEN_Y = 448
URL = "http://localhost:4000/"

chrome_options = Options()
chrome_options.add_argument("--headless")

driver = None


def startup():
    global driver
    try:
        display = Display(visible=0, size=(SCREEN_X, SCREEN_Y))
        display.start()
        driver = webdriver.Chrome(options=chrome_options)
        driver.get(URL)
    except Exception as e:
        print(e)


def shutdown():
    global driver
    if driver:
        driver.quit()


@asynccontextmanager
async def lifespan(app: FastAPI):
    startup()
    yield
    shutdown()


app = FastAPI(lifespan=lifespan)


@app.get("/")
async def root():
    return {"message": "Hello World"}


@app.get("/screenshot", response_class=StreamingResponse)
async def screenshot():
    screenshot_png = driver.get_screenshot_as_png()
    image = Image.open(io.BytesIO(screenshot_png))
    img_byte_arr = io.BytesIO()
    image.save(img_byte_arr, format="PNG")
    img_byte_arr.seek(0)

    return StreamingResponse(img_byte_arr, media_type="image/png")


if __name__ == "__main__":
    uvicorn.run("main:app", port=8000, log_level="info")
