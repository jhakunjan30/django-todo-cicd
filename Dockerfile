FROM python:3.13-slim

# Install system dependencies, including distutils replacement
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-setuptools \
    python3-venv \
    gcc \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /data

# Install Python dependencies first to leverage Docker layer caching
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# Run migrations (after Django is installed!)
RUN python manage.py migrate

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
