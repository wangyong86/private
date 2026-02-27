#!/usr/bin/env bash

# --- 1. 全局变量与环境配置 ---
SET_LOG_NUM=10
SET_PKG_PATTERN="compute-service-gpdb6*.tar.gz"
SET_TARGET_DIR="compute-service-gpdb6"

# 颜色抽象 (保持并优化：使用 printf 或 echo -e)
C_RED='\033[31m'
C_GREEN='\033[32m'
C_CYAN='\033[36m'
C_NC='\033[0m' # No Color

# 错误处理函数 (标准做法：统一报错出口)
die() {
    echo -e "${C_RED}Error:${C_NC} $1" >&2
    exit 1
}

# --- 2. 初始校验 ---
[ $# -lt 1 ] && die "Must specify release directory. Usage: $0 <dir>"
RELEASE_DIR="$1"

echo "Begin at: $(date)"

# --- 3. 目录与解压逻辑 ---
# 标准做法：先判断，不存在直接报错，不盲目 cd
cd "$RELEASE_DIR" || die "Directory '$RELEASE_DIR' does not exist."

# 解压文件 (带基本检查)
ls "$SET_PKG_PATTERN" >/dev/null 2>&1 || die "Package $SET_PKG_PATTERN not found in $RELEASE_DIR"
tar xvzf "$SET_PKG_PATTERN" >/dev/null

# 检查解压后的目标目录
cd "$SET_TARGET_DIR" || die "Decompression failed: Directory '$SET_TARGET_DIR' not found."
echo -e "${C_GREEN}OK:${C_NC} Decompressed package successfully"

# --- 4. 依赖项检查 (deps) ---
items=$(find deps -maxdepth 1 -mindepth 1 2>/dev/null | wc -l)
if [ "$items" -gt 1 ]; then
    echo -e "${C_RED}Error${C_NC}: Excessive files in deps. Detail:"
    ls -l deps
else
    echo -e "${C_GREEN}OK:${C_NC} No excessive files in deps"
fi

# --- 5. Git 状态检查 ---
echo "The latest $SET_LOG_NUM commits:"
echo -ne "${C_CYAN}"
git log --oneline -n "$SET_LOG_NUM" 2>/dev/null || echo "  (Note: Not a git repository)"
echo -ne "${C_NC}"

# --- 6. 子模块合规性检查 (contrib) ---
cd contrib || die "Missing 'contrib' directory."

# 检查 cnati (不应包含)
if ls cnati* >/dev/null 2>&1; then
    echo -e "${C_RED}Error${C_NC}: Test library (cnati) is included"
else
    echo -e "${C_GREEN}OK${C_NC}: Test library is not included"
fi

# 检查 mxvector (不应包含)
if ls mxvector* >/dev/null 2>&1; then
    echo -e "${C_RED}Error${C_NC}: mxvector is included unexpectedly"
else
    echo -e "${C_GREEN}OK${C_NC}: mxvector is not included"
fi

# --- 7. 深度校验 (mars2x) ---
MARS_PATH="matrixts/mars2x"
if [ -d "$MARS_PATH" ]; then
    echo -e "${C_GREEN}OK${C_NC}: $MARS_PATH exists"

    # 文件数量校验
    m_items=$(find "$MARS_PATH" -maxdepth 1 -mindepth 1| wc -l)
    if [ "$m_items" -gt 2 ]; then
        echo -e "${C_RED}Error${C_NC}: Excessive files in $MARS_PATH (Found: $m_items)"
    else
        echo -e "${C_GREEN}OK${C_NC}: File count in $MARS_PATH is correct"
    fi
else
    echo -e "${C_RED}Error${C_NC}: $MARS_PATH directory is MISSING"
fi

echo "End at: $(date)"
