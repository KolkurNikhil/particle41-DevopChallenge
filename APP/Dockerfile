FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

RUN useradd -u 1001 -m simpleuser

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .
RUN chown -R simpleuser:simpleuser /app

USER simpleuser

EXPOSE 5000

CMD ["python", "app.py"]

