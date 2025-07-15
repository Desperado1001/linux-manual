#!/bin/bash
# 编译第2章所有示例代码

echo "编译第2章所有示例代码..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success_count=0
fail_count=0

# 编译函数
compile_section() {
    local section=$1
    local section_name=$2
    
    echo -e "\n${YELLOW}=== 编译 $section_name ===${NC}"
    
    if [ -d "$section/examples" ]; then
        cd "$section/examples"
        
        # 查找所有C文件
        for c_file in *.c; do
            if [ -f "$c_file" ]; then
                # 获取文件名（不含扩展名）
                prog_name="${c_file%.c}"
                
                echo -n "编译 $c_file -> $prog_name ... "
                
                # 编译命令
                if gcc -Wall -Wextra -g -o "$prog_name" "$c_file" 2>/dev/null; then
                    echo -e "${GREEN}成功${NC}"
                    ((success_count++))
                else
                    echo -e "${RED}失败${NC}"
                    ((fail_count++))
                    # 显示详细错误信息
                    echo "错误详情:"
                    gcc -Wall -Wextra -g -o "$prog_name" "$c_file"
                fi
            fi
        done
        
        cd - > /dev/null
    else
        echo "目录 $section/examples 不存在，跳过"
    fi
}

# 编译各个章节
compile_section "2.1_kernel_core" "操作系统核心"
compile_section "2.2_shell" "Shell"
compile_section "2.3_users_groups" "用户和组"
compile_section "2.4_filesystem" "文件系统"
compile_section "2.5_file_io" "文件I/O"
compile_section "2.6_programs" "程序"
compile_section "2.7_processes" "进程"
compile_section "2.8_memory_mapping" "内存映射"
compile_section "2.9_libraries" "库"
compile_section "2.10_ipc_sync" "IPC和同步"
compile_section "2.11_signals" "信号"
compile_section "2.12_threads" "线程"
compile_section "2.13_process_groups" "进程组"
compile_section "2.14_sessions" "会话"
compile_section "2.15_pseudoterminals" "伪终端"
compile_section "2.16_datetime" "日期时间"
compile_section "2.17_client_server" "客户端服务器"
compile_section "2.18_realtime" "实时性"
compile_section "2.19_proc_filesystem" "/proc文件系统"

# 统计结果
echo -e "\n${YELLOW}=== 编译统计 ===${NC}"
echo -e "成功: ${GREEN}$success_count${NC}"
echo -e "失败: ${RED}$fail_count${NC}"
echo -e "总计: $((success_count + fail_count))"

if [ $fail_count -eq 0 ]; then
    echo -e "\n${GREEN}所有代码编译成功！${NC}"
    exit 0
else
    echo -e "\n${RED}有 $fail_count 个文件编译失败，请检查代码。${NC}"
    exit 1
fi