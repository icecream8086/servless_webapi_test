#!/bin/bash
cd /home/src

# 处理传入参数并更新info.json
for arg in "$@"; do
  if [[ "$arg" == *=* ]]; then
    key="${arg%%=*}"
    value="${arg#*=}"
    
    # 使用jq工具安全更新JSON
    if [ -f info.json ]; then
      jq --arg k "$key" --arg v "$value" '.[$k] = $v' info.json > tmp.json && \
      mv tmp.json info.json
    else
      echo "{ \"$key\": \"$value\" }" > info.json
    fi
  fi
done

# 设置调试环境变量并启动Express应用
export DEBUG=src:*
exec npm start
