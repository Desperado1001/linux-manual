# GitHub 学习工作流

本文档定义了 Linux 系统编程学习仓库的 GitHub 工作流程和最佳实践。

## 1. 分支策略 (Branching Strategy)

### 主分支 (Main Branches)
- **`master`**: 稳定的主分支，包含经过验证的学习内容
- **`develop`**: 开发分支，用于集成新的学习内容

### 功能分支 (Feature Branches)
为每个学习主题创建独立的分支：

```bash
# 分支命名规范
chapter/{章节号}-{主题名}     # 例：chapter/03-file-io
exercise/{练习名称}         # 例：exercise/socket-server
fix/{问题描述}             # 例：fix/memory-leak-chapter5
review/{复习主题}          # 例：review/signals-concepts
```

### 分支操作流程

#### 开始新的学习主题
```bash
# 从 develop 创建新分支
git checkout develop
git pull origin develop
git checkout -b chapter/04-file-systems

# 或者从 master 创建（如果 develop 不存在）
git checkout master
git pull origin master
git checkout -b chapter/04-file-systems
```

#### 完成学习内容后合并
```bash
# 推送分支到远程
git push -u origin chapter/04-file-systems

# 创建 Pull Request 到 develop 分支
gh pr create --base develop --title "Chapter 4: File Systems Implementation" \
  --body "完成第4章文件系统相关的所有示例代码和练习"

# 合并后删除本地分支
git checkout develop
git pull origin develop
git branch -d chapter/04-file-systems
```

## 2. 提交信息规范 (Commit Message Convention)

### 提交信息格式
```
<类型>(<范围>): <简短描述>

<详细描述>（可选）

<相关链接或引用>（可选）
```

### 提交类型 (Types)
- **feat**: 新增功能或示例代码
- **fix**: 修复 bug 或错误
- **docs**: 文档更新
- **style**: 代码格式调整（不影响功能）
- **refactor**: 代码重构
- **test**: 添加或修改测试
- **chore**: 构建工具、依赖更新等

### 范围 (Scope) 示例
- **chapter01**, **chapter02** 等：具体章节
- **exercise**: 练习相关
- **config**: 配置文件
- **docs**: 文档
- **tools**: 工具脚本

### 提交信息示例
```bash
# 良好的提交信息
feat(chapter03): 实现文件复制程序示例
fix(chapter05): 修复信号处理程序的内存泄漏
docs(chapter02): 添加进程管理概念说明
test(exercise): 为套接字服务器添加单元测试
chore: 更新 .gitignore 忽略编译产物

# 需要详细描述的情况
feat(chapter07): 实现共享内存 IPC 机制

- 添加 System V 共享内存示例
- 实现 POSIX 共享内存对比版本
- 包含错误处理和清理机制
- 参考书籍 7.2-7.4 节内容

相关练习: exercises/shm_server.c, exercises/shm_client.c
```

## 3. Pull Request 工作流

### PR 创建规范

#### PR 标题格式
```
[Chapter X] 主题描述
[Exercise] 练习名称
[Fix] 问题修复
[Review] 复习更新
```

#### PR 描述模板
```markdown
## 📚 学习内容概述
简要描述本次学习的主要内容和实现的功能

## 🔍 代码变更
- [ ] 新增示例代码
- [ ] 修复现有问题
- [ ] 更新文档
- [ ] 添加测试

## 📖 相关章节
- 书籍章节：第X章 X.X节
- 相关概念：[列出关键概念]

## 🧪 测试验证
- [ ] 代码编译成功
- [ ] 程序运行正常
- [ ] 使用 valgrind 检查内存
- [ ] 使用 strace 验证系统调用

## 📝 学习笔记
记录学习过程中的重点、难点和心得体会

## 🔗 参考资源
- 相关文档链接
- 参考实现
- 有用的调试工具
```

### PR 审查清单

#### 代码质量检查
- [ ] 代码风格一致
- [ ] 包含适当的注释
- [ ] 错误处理完整
- [ ] 资源正确释放
- [ ] 编译无警告

#### 学习价值检查
- [ ] 代码体现了相应的系统编程概念
- [ ] 包含必要的学习注释
- [ ] 示例具有教学价值
- [ ] 与书籍内容对应

## 4. 目录结构规范

### 标准目录结构
```
linux_manual/
├── CLAUDE.md                    # Claude 工作指南
├── GITHUB_WORKFLOW.md          # 本工作流文档
├── README.md                   # 项目总体介绍
├── .gitignore                  # Git 忽略规则
├── chapter01/                  # 第1章：历史和标准
│   ├── README.md              # 章节概述
│   ├── examples/              # 书中示例
│   ├── exercises/             # 自定义练习
│   └── notes.md              # 学习笔记
├── chapter02/                  # 第2章：基本概念
│   ├── README.md
│   ├── examples/
│   ├── exercises/
│   └── notes.md
├── tools/                      # 辅助工具
│   ├── compile.sh             # 编译脚本
│   ├── test.sh               # 测试脚本
│   └── debug.sh              # 调试脚本
└── docs/                      # 额外文档
    ├── concepts/              # 概念整理
    ├── references/            # 参考资料
    └── troubleshooting.md     # 常见问题
```

### 文件命名规范
```bash
# C 源文件
{功能描述}.c                    # 例：file_copy.c
{书中示例}_{页码}.c             # 例：listdir_p89.c
{练习编号}.c                   # 例：exercise_3_1.c

# 头文件
{模块名}.h                     # 例：error_handling.h

# 脚本文件
{功能}.sh                      # 例：compile_all.sh

# 文档文件
README.md                      # 目录说明
notes.md                       # 学习笔记
concepts.md                    # 概念整理
```

## 5. 学习进度跟踪

### 使用 Issues 跟踪学习计划

#### Issue 类型标签
- `learning-plan`: 学习计划
- `chapter-study`: 章节学习
- `exercise`: 练习题
- `review`: 复习
- `question`: 疑问讨论
- `resource`: 资源分享

#### 学习计划 Issue 模板
```markdown
## 📅 学习计划：第X章 - [章节标题]

### 🎯 学习目标
- [ ] 理解 [概念1]
- [ ] 掌握 [概念2]
- [ ] 实现 [实践内容]

### 📚 学习内容
- [ ] 阅读章节 X.1 - X.X
- [ ] 完成书中示例
- [ ] 完成课后练习
- [ ] 编写学习笔记

### ⏰ 时间安排
- 开始时间：YYYY-MM-DD
- 预计完成：YYYY-MM-DD
- 实际完成：YYYY-MM-DD

### 📝 学习笔记
[记录重要概念、难点、心得]

### 🔗 相关资源
- 参考链接
- 相关工具
- 扩展阅读
```

### 使用 Projects 管理学习进度

#### 项目看板设置
1. **📋 计划中 (Planned)**: 待学习的章节和练习
2. **🔄 进行中 (In Progress)**: 正在学习的内容
3. **✅ 已完成 (Completed)**: 完成的学习内容
4. **❓ 需要复习 (Review Needed)**: 需要重新学习的内容

## 6. 协作和分享

### 代码审查准则

#### 审查重点
1. **正确性**: 代码逻辑是否正确
2. **安全性**: 是否存在安全漏洞
3. **可读性**: 代码是否清晰易懂
4. **教学价值**: 是否有助于理解系统编程概念

#### 反馈格式
```markdown
**🎯 优点**
- 错误处理很完整
- 注释清晰易懂

**🔧 建议改进**
- 建议在第X行添加边界检查
- 可以考虑使用更高效的算法

**📚 学习价值**
- 很好地展示了系统调用的使用
- 建议添加更多关于性能的讨论
```

### 知识分享

#### Wiki 页面组织
- **概念索引**: 按主题整理的概念列表
- **代码片段库**: 常用的代码模板
- **调试技巧**: 系统编程调试方法
- **工具使用**: 开发工具使用指南
- **参考资料**: 相关书籍、文档、网站

#### 定期总结
每完成一个章节后，创建学习总结：
- 关键概念回顾
- 实践经验分享
- 常见错误和解决方案
- 进一步学习的方向

## 7. 自动化工具

### Git Hooks 设置

#### Pre-commit Hook
```bash
#!/bin/bash
# .git/hooks/pre-commit

# 检查代码编译
echo "检查代码编译..."
find . -name "*.c" -exec gcc -Wall -Wextra -c {} \; 2>/dev/null
if [ $? -ne 0 ]; then
    echo "❌ 编译检查失败，请修复代码后再提交"
    exit 1
fi

# 清理编译产物
find . -name "*.o" -delete

echo "✅ 预提交检查通过"
```

#### Commit Message Hook
```bash
#!/bin/bash
# .git/hooks/commit-msg

# 检查提交信息格式
commit_regex='^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .{1,50}'

if ! grep -qE "$commit_regex" "$1"; then
    echo "❌ 提交信息格式不符合规范"
    echo "格式：type(scope): description"
    echo "例如：feat(chapter03): 实现文件操作示例"
    exit 1
fi
```

### GitHub Actions 设置

#### 代码检查工作流
```yaml
# .github/workflows/code-check.yml
name: 代码检查

on: [push, pull_request]

jobs:
  compile-check:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: 安装依赖
      run: |
        sudo apt-get update
        sudo apt-get install -y gcc valgrind
    
    - name: 编译检查
      run: |
        find . -name "*.c" -exec gcc -Wall -Wextra -c {} \;
    
    - name: 内存检查
      run: |
        find . -name "*.c" -exec sh -c 'gcc -o temp "$1" && valgrind --leak-check=full ./temp' _ {} \;
```

## 8. 最佳实践总结

### 学习习惯
1. **小步快跑**: 每次提交包含小而完整的功能
2. **及时记录**: 遇到问题和解决方案及时记录
3. **定期复习**: 使用 Git 历史回顾学习过程
4. **主动分享**: 通过 PR 和 Issue 分享学习心得

### 代码质量
1. **编译零警告**: 使用 `-Wall -Wextra` 编译选项
2. **内存安全**: 使用 valgrind 检查内存泄漏
3. **错误处理**: 对所有系统调用进行错误检查
4. **代码注释**: 解释复杂的系统编程概念

### 版本控制
1. **有意义的提交**: 每个提交都应该有明确的目的
2. **清晰的历史**: 保持 Git 历史的清晰和线性
3. **及时推送**: 避免本地积累太多未推送的提交
4. **定期整理**: 删除不需要的分支和文件

---

## 📞 联系方式

如有任何问题或建议，请通过以下方式联系：
- 创建 Issue 讨论
- 提交 Pull Request 改进
- 在相关提交或 PR 中评论

**Happy Learning! 🚀**