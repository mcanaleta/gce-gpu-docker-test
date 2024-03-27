# Use an official Python runtime as a parent image
FROM python:3.12-slim as builder

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends gcc libpq-dev

# Install poetry
RUN pip install --upgrade pip && pip install poetry

# Set the working directory in the container
WORKDIR /app

# Copy the project files into the container at /app
COPY pyproject.toml poetry.lock* main.py /app/

# Configure Poetry
# Disable virtual env creation for Docker build
# as the dependencies are installed globally
RUN poetry config virtualenvs.create false

# Install project dependencies
RUN poetry install --no-dev --no-interaction --no-ansi

# Use a slim image for the final build
FROM python:3.12-slim as final

# Copy the built artifacts from the builder stage
COPY --from=builder /root/.cache /root/.cache
COPY --from=builder /usr/local /usr/local
COPY --from=builder /app /app

# Set the working directory in the container
WORKDIR /app

# Your application run command
CMD ["python", "main.py"]
