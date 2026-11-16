FROM python:3.11-slim

# Avoid interactive prompts and make Python output unbuffered
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    ca-certificates \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
 && rm -rf /var/lib/apt/lists/*

VOLUME ["/mvae"]

# Set working directory
WORKDIR /app

# Install Python dependencies
# Based on README: torch, torchvision, numpy, scikit-learn, scikit-learn-intelex, matplotlib
# Add scipy, pillow and lockfile (needed by Larochelle dataset loader)
RUN pip install --no-cache-dir \
    torch \
    torchvision \
    numpy \
    scikit-learn \
    scikit-learn-intelex \
    matplotlib \
    scipy \
    pillow \
    lockfile

# Copy repository into image
COPY . /app

# Default command: run the VAE training on MNIST with your desired hyperparameters.
# Output directories are redirected into the mounted volume at /mvae.
CMD ["sh", "-c", "python train.py --dataset mnist --model VAE --latent-size 32 --epochs 200 --batch-size 100 --lr 1e-3 --seed 777 --params-dir /mvae/trained_parameters --results-dir /mvae/results --curves-dir /mvae/curves --log-dir /mvae/logs"]
