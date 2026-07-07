FROM alpine:latest

# 安装 sing-box、cloudflared、supervisor 以及必要的系统工具
RUN apk add --no-cache tzdata supervisor sed curl && \
    curl -L https://github.com/SagerNet/sing-box/releases/download/v1.11.0/sing-box-1.11.0-linux-amd64.tar.gz | tar -xz && \
    mv sing-box-*-linux-amd64/sing-box /usr/local/bin/ && \
    rm -rf sing-box-* && \
    curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# 创建必要的目录
RUN mkdir -p /app /etc/supervisor/conf.d /var/log

# 将本地配置复制到容器（完美对齐到 /app 目录）
COPY config.json /app/config.json
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 引入核心注入脚本，赋予最高执行权限
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 暴露端口
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
