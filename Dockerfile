FROM python:3.11-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends procps && \
    pip install --no-cache-dir \
        pandas \
        numpy \
        scipy \
        statsmodels \
        scikit-learn \
        matplotlib \
        seaborn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /pipeline

CMD ["python", "--version"]