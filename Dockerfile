# 使用官方Python 3.10镜像作为基础镜像
FROM python:3.10-slim

# 设置环境变量
ENV PYTHONPATH=/app \
    GRADIO_SERVER_NAME=0.0.0.0 \
    DEBIAN_FRONTEND=noninteractive \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# 设置工作目录
WORKDIR /app

# 安装系统依赖
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    imagemagick \
    wget \
    && find /etc -name "policy.xml" -type f -exec sed -i 's/none/read,write/g' {} \; 2>/dev/null || true \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 复制requirements.txt
COPY requirements.txt .

# 分步安装Python依赖，先安装大型包
RUN pip install --no-cache-dir torch>=1.13,\<2.5.0 torchaudio>=0.13.0,\<2.5.0 --index-url https://download.pytorch.org/whl/cpu

# 安装其他依赖
RUN pip install --no-cache-dir -r requirements.txt

# --- PATCH g4f library for f-string SyntaxError ---
RUN sed -i "s|f\"Bearer {\"\".join(cls.api_key)}\"}|f\"Bearer {''.join(cls.api_key)}\"}|g" /usr/local/lib/python3.10/site-packages/g4f/Provider/PollinationsAI.py
# --- END PATCH ---

# 下载字体文件并清理
RUN mkdir -p font \
    && wget -q --timeout=30 --tries=3 https://isv-data.oss-cn-hangzhou.aliyuncs.com/ics/MaaS/ClipVideo/STHeitiMedium.ttc -O font/STHeitiMedium.ttc \
    && apt-get remove -y wget \
    && apt-get autoremove -y \
    && rm -rf /tmp/* /var/tmp/* /root/.cache

# 复制项目文件
COPY . .

# 暴露端口
EXPOSE 7860

# 启动命令
CMD ["python", "funclip/launch.py", "--listen", "--port", "7860"]