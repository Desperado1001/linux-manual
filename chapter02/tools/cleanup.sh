#!/bin/bash
# 清理编译产物

echo "清理第2章编译产物..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

removed_count=0

# 清理函数
cleanup_section() {
    local section=$1
    local section_name=$2
    
    echo -e "${YELLOW}清理 $section_name${NC}"
    
    if [ -d "$section" ]; then
        # 进入目录
        cd "$section"
        
        # 清理 examples 目录
        if [ -d "examples" ]; then
            cd "examples"
            
            # 删除可执行文件（没有扩展名且有对应的.c文件）
            for c_file in *.c; do
                if [ -f "$c_file" ]; then
                    prog_name="${c_file%.c}"
                    if [ -f "$prog_name" ] && [ -x "$prog_name" ]; then
                        echo "删除 $prog_name"
                        rm -f "$prog_name"
                        ((removed_count++))
                    fi
                fi
            done
            
            # 删除目标文件
            rm -f *.o *.so *.a
            
            cd ..
        fi
        
        # 清理 exercises 目录
        if [ -d "exercises" ]; then
            cd "exercises"
            
            # 删除可执行文件
            for c_file in *.c; do
                if [ -f "$c_file" ]; then
                    prog_name="${c_file%.c}"
                    if [ -f "$prog_name" ] && [ -x "$prog_name" ]; then
                        echo "删除 $prog_name"
                        rm -f "$prog_name"
                        ((removed_count++))
                    fi
                fi
            done
            
            # 删除目标文件
            rm -f *.o *.so *.a
            
            cd ..
        fi
        
        cd ..
    fi
}

# 清理各个章节
cleanup_section "2.1_kernel_core" "操作系统核心"
cleanup_section "2.2_shell" "Shell"
cleanup_section "2.3_users_groups" "用户和组"
cleanup_section "2.4_filesystem" "文件系统"
cleanup_section "2.5_file_io" "文件I/O"
cleanup_section "2.6_programs" "程序"
cleanup_section "2.7_processes" "进程"
cleanup_section "2.8_memory_mapping" "内存映射"
cleanup_section "2.9_libraries" "库"
cleanup_section "2.10_ipc_sync" "IPC和同步"
cleanup_section "2.11_signals" "信号"
cleanup_section "2.12_threads" "线程"
cleanup_section "2.13_process_groups" "进程组"
cleanup_section "2.14_sessions" "会话"
cleanup_section "2.15_pseudoterminals" "伪终端"
cleanup_section "2.16_datetime" "日期时间"
cleanup_section "2.17_client_server" "客户端服务器"
cleanup_section "2.18_realtime" "实时性"
cleanup_section "2.19_proc_filesystem" "/proc文件系统"

# 统计结果
echo -e "\n${GREEN}清理完成！删除了 $removed_count 个文件。${NC}"

# 显示磁盘使用情况
echo -e "\n${YELLOW}当前目录大小:${NC}"
du -sh . 2>/dev/null || echo "无法获取目录大小"