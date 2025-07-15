# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a learning repository for Linux system programming, primarily based on "The Linux Programming Interface" by Michael Kerrisk (Linux-UNIX系统编程手册). The repository contains practical examples, exercises, and implementations of concepts from the book.

## Repository Structure

- Each chapter from the book should have its own directory (e.g., `chapter01/`, `chapter02/`)
- Code examples should be organized by topic within each chapter
- Include both book examples and custom practice exercises
- Add README files in each chapter directory to explain the concepts covered

## Development Commands

### Compilation
```bash
# Compile individual C programs
gcc -o program_name source_file.c

# Compile with debugging symbols
gcc -g -o program_name source_file.c

# Compile with warnings
gcc -Wall -Wextra -o program_name source_file.c

# Link with specific libraries (common for system programming)
gcc -o program_name source_file.c -lpthread  # for pthread
gcc -o program_name source_file.c -lrt       # for real-time extensions
```

### Testing and Execution
```bash
# Run programs with strace to trace system calls
strace ./program_name

# Run with valgrind for memory debugging
valgrind --leak-check=full ./program_name

# Check program behavior
./program_name && echo "Success" || echo "Failed"
```

## Architecture Notes

- Focus on system call interfaces and low-level programming concepts
- Examples should demonstrate proper error handling for system calls
- Include both POSIX-compliant and Linux-specific implementations where relevant
- Practice programs should explore process management, file I/O, signals, IPC, and network programming

## Learning Approach

- Each example should include comments explaining the system programming concepts
- Test programs in different scenarios to understand edge cases
- Use system tools like `ps`, `lsof`, `netstat` to observe program behavior
- Compare theoretical concepts from the book with practical implementation