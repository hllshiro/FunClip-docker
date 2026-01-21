# 使用官方Python 3.9镜像作为基础镜像
FROM python:3.9-slim

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y \
    ffmpeg \
    imagemagick \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# 修改ImageMagick策略以允许读写操作
RUN find /etc -name "policy.xml" -type f -exec sed -i 's/none/read,write/g' {} \; 2>/dev/null || true

# 复制requirements.txt并安装Python依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 复制项目文件
COPY . .

# 创建字体目录并下载字体文件
RUN mkdir -p font && \
    wget https://isv-data.oss-cn-hangzhou.aliyuncs.com/ics/MaaS/ClipVideo/STHeitiMedium.ttc -O font/STHeitiMedium.ttc

# 暴露端口
EXPOSE 7860

# 设置环境变量
ENV PYTHONPATH=/app
ENV GRADIO_SERVER_NAME=0.0.0.0

# 启动命令
CMD ["python", "funclip/launch.py", "--listen", "--port", "7860"]
