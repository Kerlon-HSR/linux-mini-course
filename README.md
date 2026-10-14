# Demystifying Linux: From Desktop to Engineering

Welcome to the hands-on repository for the **"Demystifying Linux: From Desktop to Engineering"** mini-course. This repository contains all code samples, automation scripts, Docker configurations, and reference material used during the 2.5-hour workshop.

## Repository Structure

```text

├── 01-scripts/       # Bash and Python automation scripts
│   ├── setup.sh
│   └── report.py
├── 02-docker/        # Dockerfile and containerized application sample
│   ├── Dockerfile
│   └── app.py
└── cheat-sheet.md    # Quick reference guide for essential Linux commands

```

## Prerequisites & Setup

All required tools come pre-installed in the provided VirtualBox Virtual Machine (`.ova` image). If running on a custom environment, ensure you have:

* **OS:** Ubuntu 26.04.01 LTS
* **Tools:** `git`, `curl`, `micro`, `fastfetch`, `btop`, `yazi`, `lazygit`, `docker.io`, `python3`

## Workshop Quick Start

### 1. Clone the Repository

```bash
git clone [https://github.com/](https://github.com/)<your-username>/demystifying-linux-course.git
cd demystifying-linux-course

```

### 2. Automation Scripts (Module 2)

```bash
cd 01-scripts

# Grant execution permission and run the Bash setup script
chmod +x setup.sh
./setup.sh

# Run the Python report generator
python3 report.py

```

### 3. Docker Containerization (Module 4)

```bash
cd ../02-docker

# Build the Docker image
docker build -t linux-course-app:1.0 .

# Run the isolated container
docker run --rm linux-course-app:1.0

```

### 4. Terminal User Interfaces (TUIs)

Explore terminal utilities during the workshop:

```bash
fastfetch    # Display system overview
btop         # Resource monitoring
yazi         # Terminal file manager
lazygit      # Terminal Git interface

```

---

### 7. `cheat-sheet.md`

```markdown
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

```-
