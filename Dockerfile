FROM node:latest

# 设置工作目录
WORKDIR /home

# 复制应用代码
COPY src ./src

# 安装依赖
RUN cd src && npm install

# 创建启动脚本（适配Linux环境）
RUN echo $'#!/bin/bash\n\
cd /home/src\n\
\n\
# 处理传入参数并更新info.json\n\
for arg in "$@"; do\n\
  if [[ "$arg" == *=* ]]; then\n\
    key="${arg%%=*}"\n\
    value="${arg#*=}"\n\
    \n\
    # 使用jq工具安全更新JSON\n\
    if [ -f info.json ]; then\n\
      jq --arg k "$key" --arg v "$value" \'.[$k] = $v\' info.json > tmp.json && \\\n\
      mv tmp.json info.json\n\
    else\n\
      echo "{ \\\"$key\\\": \\\"$value\\\" }" > info.json\n\
    fi\n\
  fi\n\
done\n\
\n\
# 设置调试环境变量并启动Express应用\n\
export DEBUG=src:*\n\
exec npm start' > entrypoint.sh

# 安装jq用于JSON处理
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# 设置脚本权限
RUN chmod +x entrypoint.sh

# 设置入口点
ENTRYPOINT ["./entrypoint.sh"]
