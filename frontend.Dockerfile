# 阶段1：构建前端（简化，直接用Nginx托管静态文件）
FROM nginx:alpine

# 清除Nginx默认配置
RUN rm -rf /usr/share/nginx/html/* /etc/nginx/conf.d/default.conf

# 复制前端配置和页面
COPY frontend/nginx.conf /etc/nginx/conf.d/default.conf
COPY frontend/index.html /usr/share/nginx/html/index.html

# 暴露前端端口（80）
EXPOSE 80

# 启动Nginx（前台运行，适配Docker）
CMD ["nginx", "-g", "daemon off;"]