# Pull official base image
FROM --platform=linux/amd64 python:alpine3.19

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/scripts:${PATH}"

# Set work directory
WORKDIR /app

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install required dependencies
COPY ./app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# Create a user with UID 1000 and GID 1000
RUN groupadd -g 1000 appgroup && \
    useradd -r -u 1000 -g appgroup appuser
# Switch to this user
USER 1000:1000

COPY ./app/ /app/

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8081"]
