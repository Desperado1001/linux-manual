# 2.7 进程

## 概述

进程是程序执行的实例，是操作系统进行资源分配和调度的基本单位。理解进程概念对于系统编程至关重要。

## 核心概念

### 程序 vs 进程
- **程序**: 存储在磁盘上的可执行文件，是静态的代码和数据集合
- **进程**: 程序在内存中执行的实例，是动态的概念，包含程序代码、数据、系统资源等

### 进程标识
- **PID (Process ID)**: 每个进程的唯一标识符
- **PPID (Parent Process ID)**: 父进程的PID
- **PGID (Process Group ID)**: 进程组标识符

### 进程生命周期
1. **创建**: 通过 `fork()` 系统调用创建新进程
2. **执行**: 通过 `exec()` 族函数替换进程映像
3. **等待**: 父进程可以等待子进程结束
4. **终止**: 进程正常或异常结束

## 重要系统调用

### 进程创建和管理
```c
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>

// 创建子进程
pid_t fork(void);

// 获取进程ID
pid_t getpid(void);
pid_t getppid(void);

// 等待子进程
pid_t wait(int *status);
pid_t waitpid(pid_t pid, int *status, int options);

// 执行新程序
int execl(const char *path, const char *arg, ...);
int execlp(const char *file, const char *arg, ...);
int execv(const char *path, char *const argv[]);
int execvp(const char *file, char *const argv[]);
```

### 进程终止
```c
#include <stdlib.h>

// 正常终止
void exit(int status);
void _exit(int status);

// 异常终止
#include <signal.h>
int kill(pid_t pid, int sig);
```

## 学习重点

### 1. fork() 系统调用
- 理解 fork() 的工作机制
- 掌握父子进程的区别
- 理解返回值的含义

### 2. exec() 族函数
- 理解程序替换的概念
- 掌握不同 exec() 函数的使用
- 理解环境变量的传递

### 3. 进程等待
- 理解僵尸进程和孤儿进程
- 掌握 wait() 和 waitpid() 的使用
- 理解进程状态码

### 4. 进程终止
- 理解正常终止和异常终止
- 掌握退出状态的含义
- 理解信号与进程终止的关系

## 示例程序

### 基础示例
- `process_info.c` - 获取进程信息
- `fork_demo.c` - fork() 系统调用演示
- `exec_demo.c` - exec() 族函数演示
- `wait_demo.c` - 进程等待演示

### 实践练习
- `simple_shell.c` - 简单Shell实现
- `process_tree.c` - 进程树显示
- `parallel_tasks.c` - 并行任务执行

## 调试和观察

### 系统工具
```bash
# 查看进程信息
ps aux
ps -ef
pstree

# 实时监控
top
htop

# 进程详细信息
cat /proc/[PID]/status
cat /proc/[PID]/cmdline
```

### 调试技巧
```bash
# 跟踪系统调用
strace -f ./program

# 调试多进程程序
gdb --args ./program
(gdb) set follow-fork-mode child
(gdb) set detach-on-fork off
```

## 常见错误和问题

### 1. 僵尸进程
- **原因**: 子进程终止但父进程未调用 wait()
- **解决**: 及时调用 wait() 或设置 SIGCHLD 信号处理

### 2. 孤儿进程
- **原因**: 父进程先于子进程终止
- **结果**: init 进程成为孤儿进程的父进程

### 3. fork() 失败
- **原因**: 系统资源不足
- **处理**: 检查返回值并适当处理错误

## 实验建议

1. **基础实验**
   - 编写程序创建子进程并观察PID变化
   - 实验不同的 exec() 函数
   - 观察进程的父子关系

2. **进阶实验**
   - 实现一个简单的进程池
   - 编写进程监控工具
   - 实现进程间的简单通信

3. **系统观察**
   - 使用系统工具观察进程状态
   - 分析进程的内存布局
   - 观察进程的环境变量

## 参考资料

- `man 2 fork`
- `man 3 exec`
- `man 2 wait`
- `man 7 signal`
- `/proc` 文件系统文档