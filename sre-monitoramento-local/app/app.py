import time
from flask import Flask, Response
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

REQUESTS_TOTAL = Counter(
    "app_requests_total",
    "Total de requests HTTP",
    ["method", "path", "status"],
)

REQUEST_LATENCY_SECONDS = Histogram(
    "app_request_latency_seconds",
    "Latência de requests HTTP em segundos",
    ["path"],
)

START_TIME = time.time()


@app.get("/")
def home():
    start = time.time()
    status = 200
    try:
        return {"message": "ok"}
    finally:
        REQUESTS_TOTAL.labels("GET", "/", str(status)).inc()
        REQUEST_LATENCY_SECONDS.labels("/").observe(time.time() - start)


@app.get("/health")
def health():
    return {"status": "UP"}


@app.get("/metrics")
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)


@app.get("/uptime")
def uptime():
    return {"uptime_seconds": int(time.time() - START_TIME)}