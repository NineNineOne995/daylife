# Dockerfile

# 1. 构建阶段：使用 Node.js 镜像来打包项目
FROM node:18-alpine AS builder

WORKDIR /app

# 复制 package.json 并安装依赖 (利用缓存)
COPY package*.json ./
RUN npm ci

# 复制所有源代码并执行构建
COPY . .
RUN npm run build

# 2. 生产阶段：使用轻量级的 Nginx 镜像来托管静态文件
FROM nginx:alpine

# 将构建阶段生成的 dist 目录复制到 Nginx 的默认托管目录
COPY --from=builder /app/dist /usr/share/nginx/html

# (可选) 复制自定义的 nginx.conf 以支持 History 路由等
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]