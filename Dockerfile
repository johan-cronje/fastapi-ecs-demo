# Pull official base image
FROM python:alpine3.19

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV PATH="/scripts:${PATH}"

# Set work directory
WORKDIR /app

# Upgrade base image
RUN apk upgrade --no-cache

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

# Install required dependencies
COPY ./app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade -r /app/requirements.txt

# Create a user with UID 1000 and GID 1000
RUN addgroup -g 10001 app && \
    adduser \
    --disabled-password \
    --gecos "" \
    --home "$(pwd)" \
    --ingroup app \
    --no-create-home \
    --uid 10000 \
    "app"
# Switch to this user
USER app:app

COPY ./app/ /app/

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8081"]