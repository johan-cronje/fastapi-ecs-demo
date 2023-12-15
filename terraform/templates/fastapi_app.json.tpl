[
  {
    "name": "fastapi-app",
    "image": "${docker_image_url_fastapi}",
    "essential": true,
    "cpu": 10,
    "memory": 512,
    "portMappings": [
      {
        "containerPort": 8000,
        "protocol": "tcp"
      }
    ],
    "command": ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"],
    "environment": [],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/fastapi-app",
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "fastapi-app-log-stream"
      }
    }
  }
]
