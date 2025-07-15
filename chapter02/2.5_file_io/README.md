# 2.5 文件I/O模型

## 概述

文件I/O是Linux系统编程的基础，所有的输入输出操作都基于文件描述符。理解文件I/O模型对于掌握系统编程至关重要。

## 核心概念

### 文件描述符 (File Descriptor)
- **定义**: 非负整数，用于标识打开的文件
- **标准文件描述符**:
  - 0: 标准输入 (stdin)
  - 1: 标准输出 (stdout) 
  - 2: 标准错误 (stderr)

### I/O操作模型
- **系统调用接口**: 直接使用内核提供的系统调用
- **标准I/O库**: C库提供的缓冲I/O接口
- **内存映射I/O**: 将文件映射到内存中

## 重要系统调用

### 文件操作
```c
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

// 打开/创建文件
int open(const char *pathname, int flags);
int open(const char *pathname, int flags, mode_t mode);
int creat(const char *pathname, mode_t mode);

// 读写操作
ssize_t read(int fd, void *buf, size_t count);
ssize_t write(int fd, const void *buf, size_t count);

// 定位操作
off_t lseek(int fd, off_t offset, int whence);

// 关闭文件
int close(int fd);
```

### 文件信息
```c
#include <sys/stat.h>

// 获取文件状态
int stat(const char *pathname, struct stat *statbuf);
int fstat(int fd, struct stat *statbuf);
int lstat(const char *pathname, struct stat *statbuf);

// 文件权限
int access(const char *pathname, int mode);
int chmod(const char *pathname, mode_t mode);
int fchmod(int fd, mode_t mode);
```

## 文件打开标志

### 访问模式 (互斥)
- `O_RDONLY`: 只读
- `O_WRONLY`: 只写  
- `O_RDWR`: 读写

### 文件创建标志
- `O_CREAT`: 文件不存在时创建
- `O_EXCL`: 与 O_CREAT 一起使用，文件存在时失败
- `O_TRUNC`: 截断文件为0长度

### 文件状态标志
- `O_APPEND`: 追加模式
- `O_NONBLOCK`: 非阻塞模式
- `O_SYNC`: 同步写入

## 学习重点

### 1. 文件描述符概念
- 理解文件描述符表
- 掌握文件描述符的复制和重定向
- 理解文件描述符的继承

### 2. 系统调用vs库函数
- 理解系统调用的直接性
- 掌握缓冲的概念和影响
- 了解性能差异

### 3. 错误处理
- 掌握errno的使用
- 理解EINTR中断处理
- 学会合理的错误恢复

### 4. 文件权限和属性
- 理解Unix权限模型
- 掌握文件类型判断
- 学会文件属性的读取

## 示例程序

### 基础示例
- `basic_io.c` - 基本文件读写操作
- `file_descriptors.c` - 文件描述符操作
- `file_copy.c` - 文件复制程序
- `file_info.c` - 文件信息获取

### 进阶示例
- `buffered_vs_unbuffered.c` - 缓冲I/O对比
- `file_holes.c` - 文件空洞处理
- `atomic_append.c` - 原子追加操作
- `nonblock_io.c` - 非阻塞I/O

## 性能考虑

### 缓冲大小
```c
// 不同缓冲大小的性能测试
#define BUFFER_SIZE_1K   1024
#define BUFFER_SIZE_4K   4096
#define BUFFER_SIZE_64K  65536

// 测试不同缓冲大小对性能的影响
```

### 系统调用优化
- 减少系统调用次数
- 使用适当的缓冲区大小
- 考虑使用内存映射I/O

## 调试和测试

### 系统工具
```bash
# 监控文件操作
strace -e trace=file ./program
strace -e trace=read,write ./program

# 查看打开的文件
lsof -p PID
ls -la /proc/PID/fd/

# 文件系统信息
df -h
du -sh directory/
```

### 性能测试
```bash
# 测试I/O性能
time ./file_copy source dest
dd if=/dev/zero of=testfile bs=1M count=100
```

## 常见问题

### 1. 文件描述符泄漏
- **问题**: 忘记关闭文件描述符
- **后果**: 系统资源耗尽
- **解决**: 及时调用 close()，使用RAII模式

### 2. 缓冲区溢出
- **问题**: 读取数据超过缓冲区大小
- **后果**: 内存安全问题
- **解决**: 仔细检查缓冲区边界

### 3. 部分读写
- **问题**: read/write 可能不会处理全部数据
- **后果**: 数据丢失或不完整
- **解决**: 循环处理直到完成

## 最佳实践

### 1. 错误处理
```c
int fd = open(filename, O_RDONLY);
if (fd == -1) {
    perror("open");
    exit(EXIT_FAILURE);
}
```

### 2. 安全的读写
```c
ssize_t safe_read(int fd, void *buf, size_t count) {
    ssize_t total = 0;
    ssize_t n;
    
    while (total < count) {
        n = read(fd, (char*)buf + total, count - total);
        if (n == -1) {
            if (errno == EINTR) continue;
            return -1;
        }
        if (n == 0) break;  // EOF
        total += n;
    }
    return total;
}
```

### 3. 资源管理
```c
void process_file(const char *filename) {
    int fd = open(filename, O_RDONLY);
    if (fd == -1) return;
    
    // 处理文件...
    
    close(fd);  // 确保关闭文件
}
```

## 实验建议

1. **基础实验**
   - 实现文件复制程序
   - 测试不同缓冲区大小的性能
   - 观察文件描述符的行为

2. **进阶实验**
   - 实现tail命令
   - 编写文件比较工具
   - 实现简单的文本编辑器

3. **性能实验**
   - 比较系统调用和库函数的性能
   - 测试顺序访问vs随机访问
   - 分析I/O瓶颈

## 参考资料

- `man 2 open`
- `man 2 read`
- `man 2 write`
- `man 2 lseek`
- `man 2 stat`
- Advanced Programming in the UNIX Environment - Chapter 3