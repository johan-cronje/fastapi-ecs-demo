from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Hello from FastAPI"}

if __name__ == '__main__':
    uvicorn.run("0.0.0.0", port=8081, reload=True, access_log=False)
