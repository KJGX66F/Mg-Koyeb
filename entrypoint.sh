#!/bin/sh

# 确保 /app 目录存在
mkdir -p /app

# 1. 检查 Koyeb 环境变量中是否配置了 UUID
if [ -n "$UUID" ]; then
    echo "[INFO] 检测到环境变量 UUID，正在执行安全注入..."
    # 路径已完美对齐到 /app/config.json
    sed -i "s/UUID_PLACEHOLDER/$UUID/g" /app/config.json
    echo "[INFO] UUID 安全注入完成！"
else
    echo "[WARN] 未检测到环境变量 UUID，将使用默认占位符！"
fi

# 2. 检查并动态对齐隧道端口
if [ -n "$PORT" ]; then
    echo "[INFO] 正在对齐内部监听端口为: $PORT"
    sed -i "s/8080/$PORT/g" /app/config.json
fi

# 3. 🎉 智能拼接并高亮输出万能通用快捷节点链接
echo "=================================================================="
echo "🚀 YouTube 科技共享 恭喜您 专属容器部署成功！您的 VLESS 万能快捷导入节点如下："
echo "------------------------------------------------------------------"
if [ -n "$UUID" ] && [ -n "$SUBDOMAIN" ]; then
    echo "vless://${UUID}@${SUBDOMAIN}:443?encryption=none&security=tls&sni=${SUBDOMAIN}&type=ws&host=${SUBDOMAIN}&path=%2Fblog#Koyeb-Argo-自用输出"
else
    echo "[提示] 如果需要自动输出成品链接，请在 Koyeb 环境变量里补全 SUBDOMAIN 参数"
fi
echo "=================================================================="

# 4. 拉起双进程保活管理器
echo "[INFO] 正在唤醒 cloudflared 隧道与 sing-box 服务..."
exec supervisord -c /etc/supervisor/conf.d/supervisord.conf
