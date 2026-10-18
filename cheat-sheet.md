# Essential Linux Command Cheat Sheet

## Directory & File Operations
- `pwd`: Print current working directory path
- `ls -la`: List files with details and hidden files
- `cd <dir>`: Change directory (`cd ..` to go up one level)
- `mkdir -p <dir>`: Create nested directories
- `touch <file>`: Create an empty file
- `rm -rf <file/dir>`: Remove file or directory recursively
- `cp -r <src> <dest>`: Copy file or directory
- `mv <src> <dest>`: Move or rename file/directory

## Permissions & System
- `chmod +x <file>`: Make file executable
- `chmod 644 <file>`: Set read/write for owner, read-only for others
- `sudo apt update && sudo apt install <package>`: Install software via package manager
- `systemctl status <service>`: Check status of a system service

## Process Monitoring
- `btop`: Interactive resource monitor
- `htop`: Interactive process viewer
- `killall <process_name>`: Terminate process by name

## Git & Version Control
- `git init`: Initialize repository
- `git status`: Check working tree status
- `git add .`: Stage all modified files
- `git commit -m "message"`: Commit changes
- `lazygit`: Terminal UI for Git workflow
