# FunClip Docker 构建指南

## 使用 GitHub Actions 自动构建

### 1. 设置 Docker Hub 认证

在你的 GitHub 仓库中设置以下 Secrets：

1. 进入你的 GitHub 仓库
2. 点击 `Settings` -> `Secrets and variables` -> `Actions`
3. 添加以下 Repository secrets：
   - `DOCKERHUB_USERNAME`: 你的 Docker Hub 用户名
   - `DOCKERHUB_TOKEN`: 你的 Docker Hub 访问令牌

### 2. 获取 Docker Hub 访问令牌

1. 登录 [Docker Hub](https://hub.docker.com/)
2. 点击右上角头像 -> `Account Settings`
3. 选择 `Security` 标签
4. 点击 `New Access Token`
5. 输入令牌名称（如：github-actions）
6. 选择权限（建议选择 `Read, Write, Delete`）
7. 复制生成的令牌

### 3. 运行构建

1. 进入你的 GitHub 仓库
2. 点击 `Actions` 标签
3. 选择 `Docker FunClip Build` workflow
4. 点击 `Run workflow`
5. 选择构建平台：
   - `ALL`: 构建 AMD64 和 ARM64 两个架构
   - `AMD64`: 仅构建 AMD64 架构
   - `ARM64`: 仅构建 ARM64 架构
6. 输入镜像标签（可选，默认为 latest）
7. 点击 `Run workflow` 开始构建

### 4. 构建结果

构建完成后，镜像将推送到你的 Docker Hub 仓库，标签格式为：
- `你的用户名/funclip:latest`
- `你的用户名/funclip:自定义标签`
- `你的用户名/funclip:YYYYMMDD`（构建日期）

## 本地使用构建的镜像

### 拉取镜像
```bash
docker pull 你的用户名/funclip:latest
```

### 运行容器
```bash
# 使用 docker run
docker run -d \
  --name funclip \
  -p 7860:7860 \
  -v ./input:/app/input \
  -v ./output:/app/output \
  你的用户名/funclip:latest

# 或使用 docker-compose（修改 docker-compose.yml 中的镜像名）
# 将 build: . 替换为 image: 你的用户名/funclip:latest
docker-compose up -d
```

### 访问应用
打开浏览器访问：http://localhost:7860

## 优势

- **快速构建**: 利用 GitHub Actions 的云端资源，比本地构建快得多
- **多架构支持**: 同时构建 AMD64 和 ARM64 架构
- **缓存优化**: 使用 GitHub Actions 缓存加速后续构建
- **自动推送**: 构建完成后自动推送到 Docker Hub
- **版本管理**: 自动生成日期标签，便于版本管理

## 注意事项

1. 首次构建可能需要较长时间（约10-20分钟），后续构建会因为缓存而加速
2. 确保你的 Docker Hub 账户有足够的存储空间
3. 如果构建失败，检查 Secrets 配置是否正确
4. ARM64 架构构建时间可能较长，如果只需要 AMD64 可以选择对应平台