FROM python:3.10-slim-bullseye

WORKDIR /FunClip

RUN chmod 777 /FunClip

ENV PYTHONPATH="/FunClip"

RUN apt-get update && apt-get install -y \
    git \
    imagemagick \
    ffmpeg \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i '/<policy domain="path" rights="none" pattern="@\*"/d' /etc/ImageMagick-6/policy.xml

COPY requirements.txt ./

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 7860

CMD ["python", "funclip/launch.py"]
