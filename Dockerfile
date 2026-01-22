# 多阶段构建版本 - 更小的最终镜像
# 构建阶段
FROM python:3.10-slim as builder

# 设置环境变量
ENV DEBIAN_FRONTEND=noninteractive

# 安装构建依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 复制requirements.txt并安装Python依赖到临时目录
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir --user -r requirements.txt

# 下载字体文件
RUN mkdir -p font \
    && wget -q https://isv-data.oss-cn-hangzhou.aliyuncs.com/ics/MaaS/ClipVideo/STHeitiMedium.ttc -O font/STHeitiMedium.ttc

# 运行阶段
FROM python:3.10-slim

# 设置环境变量
ENV PYTHONPATH=/app \
    GRADIO_SERVER_NAME=0.0.0.0 \
    DEBIAN_FRONTEND=noninteractive \
    PATH=/root/.local/bin:$PATH

# 安装运行时依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    imagemagick \
    && find /etc -name "policy.xml" -type f -exec sed -i 's/none/read,write/g' {} \; 2>/dev/null || true \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 设置工作目录
WORKDIR /app

# 从构建阶段复制Python包
COPY --from=builder /root/.local /root/.local

# 从构建阶段复制字体文件
COPY --from=builder /app/font ./font

# 复制项目文件
COPY . .

# 暴露端口
EXPOSE 7860

# 启动命令
CMD ["python", "funclip/launch.py", "--listen", "--port", "7860"]