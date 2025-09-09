#!/bin/bash

PID=$1
if [ -z "$PID" ]; then
    echo "Usage: $0 <PID>"
    exit 1
fi

# 1. 检查cgroup文件，提取容器长ID
# format: docker-2ece1384ed278cfb0994cf7870f1d4a3e83cc0566468728d4330faa572685f48.scope
CONTAINER_ID_LONG=$(cat /proc/$PID/cgroup | tr '/' '\n' | grep -E '[0-9a-f]{64}' | head -n 1|cut -d '-' -f 2 | cut -d '.' -f 1)
CONTAINER_ID_SHORT=${CONTAINER_ID_LONG:0:12}

echo "PID: $PID"
echo "Long Container ID: $CONTAINER_ID_LONG"
echo "Short Container ID: $CONTAINER_ID_SHORT"

# 2. 尝试用Docker查找
if command -v docker &> /dev/null; then
    echo -e "\n=== Trying Docker ==="
    docker ps -a | grep $CONTAINER_ID_SHORT
fi

# 3. 尝试用crictl查找（用于Containerd）
if command -v crictl &> /dev/null; then
    echo -e "\n=== Trying Containerd (crictl) ==="
    crictl ps | grep $CONTAINER_ID_SHORT
fi

# 4. 提示用kubectl
echo -e "\n=== Next Step ==="
echo "If this is a Kubernetes pod, run on the master node:"
echo "kubectl get pods --all-namespaces -o json | grep -i $CONTAINER_ID_SHORT"
