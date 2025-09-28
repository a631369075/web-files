# 基础镜像（群晖兼容的 Python 版本）
FROM python:3.9-slim

# 关键：所有系统依赖安装必须放在同一个 RUN 指令下，gcc 是系统包（小写）
RUN apt-get update && apt-get install -y --no-install-recommends \
    libmagic1 \                  # python-magic 依赖的系统库
    gcc \                        # 编译依赖（小写，作为 apt 包，不是 Docker 指令）
    libc6-dev \                  # 解决 C 语言编译依赖
    && rm -rf /var/lib/apt/lists/*  # 清理缓存，减小镜像体积

# 设置工作目录
WORKDIR /app

# 复制依赖文件（利用 Docker 缓存）
COPY backend/requirements.txt .

# 安装 Python 依赖（阿里云源，群晖网络稳定）
RUN pip install --no-cache-dir \
    -i https://mirrors.aliyun.com/pypi/simple/ \
    --extra-index-url https://pypi.org/simple/ \
    -r requirements.txt

# 复制后端代码
COPY backend/ .

# 创建文件存储目录并授权（群晖权限适配）
RUN mkdir -p /app/files \
    && mkdir -p /app/files/pdf /app/files/word /app/files/excel /app/files/images \
    && chmod -R 775 /app/files

# 暴露端口
EXPOSE 5000

# 启动命令（群晖调试友好）
CMD ["python", "-u", "backend/app.py"]