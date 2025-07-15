#!/bin/bash
# 运行第2章所有测试程序

echo "运行第2章测试程序..."

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

test_count=0
success_count=0

# 运行测试函数
run_tests_in_section() {
    local section=$1
    local section_name=$2
    
    echo -e "\n${YELLOW}=== 测试 $section_name ===${NC}"
    
    if [ -d "$section/examples" ]; then
        cd "$section/examples"
        
        # 查找所有可执行文件
        for prog in *; do
            if [ -x "$prog" ] && [ ! -d "$prog" ] && [[ "$prog" != *.* ]]; then
                echo -e "${BLUE}运行 $prog:${NC}"
                ((test_count++))
                
                # 运行程序并捕获输出
                if timeout 5s "./$prog" 2>&1; then
                    echo -e "${GREEN}$prog 运行完成${NC}"
                    ((success_count++))
                else
                    exit_code=$?
                    if [ $exit_code -eq 124 ]; then
                        echo -e "${RED}$prog 运行超时${NC}"
                    else
                        echo -e "${RED}$prog 运行出错 (退出码: $exit_code)${NC}"
                    fi
                fi
                echo "----------------------------------------"
            fi
        done
        
        cd - > /dev/null
    else
        echo "目录 $section/examples 不存在，跳过"
    fi
}

# 测试各个章节
run_tests_in_section "2.1_kernel_core" "操作系统核心"
run_tests_in_section "2.2_shell" "Shell"
run_tests_in_section "2.3_users_groups" "用户和组"
run_tests_in_section "2.4_filesystem" "文件系统"
run_tests_in_section "2.5_file_io" "文件I/O"
run_tests_in_section "2.6_programs" "程序"
run_tests_in_section "2.7_processes" "进程"
run_tests_in_section "2.8_memory_mapping" "内存映射"
run_tests_in_section "2.9_libraries" "库"
run_tests_in_section "2.10_ipc_sync" "IPC和同步"
run_tests_in_section "2.11_signals" "信号"
run_tests_in_section "2.12_threads" "线程"
run_tests_in_section "2.13_process_groups" "进程组"
run_tests_in_section "2.14_sessions" "会话"
run_tests_in_section "2.15_pseudoterminals" "伪终端"
run_tests_in_section "2.16_datetime" "日期时间"
run_tests_in_section "2.17_client_server" "客户端服务器"
run_tests_in_section "2.18_realtime" "实时性"
run_tests_in_section "2.19_proc_filesystem" "/proc文件系统"

# 统计结果
echo -e "\n${YELLOW}=== 测试统计 ===${NC}"
echo -e "成功: ${GREEN}$success_count${NC}"
echo -e "失败: ${RED}$((test_count - success_count))${NC}"
echo -e "总计: $test_count"

if [ $success_count -eq $test_count ]; then
    echo -e "\n${GREEN}所有测试通过！${NC}"
    exit 0
else
    echo -e "\n${RED}有测试失败，请检查程序。${NC}"
    exit 1
fi