from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello from FastAPI"}

@app.get("/ping")
def pong():
    return {"ping": "pong!"}

if __name__ == '__main__':
    uvicorn.run("0.0.0.0", port=8000, reload=True, access_log=False)
