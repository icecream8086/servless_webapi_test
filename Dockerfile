FROM node:latest

# 设置工作目录
WORKDIR /home

# 复制应用代码
COPY src ./src

# 安装依赖
RUN cd src && npm install

# 复制启动脚本
COPY entrypoint.sh ./

# 安装jq用于JSON处理
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# 设置脚本权限
RUN chmod +x entrypoint.sh

# 设置入口点
ENTRYPOINT ["./entrypoint.sh"]
