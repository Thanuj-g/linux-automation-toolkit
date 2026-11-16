
# Linux Server Automation Toolkit

A Bash-based Linux administration project that automates server health monitoring, backups, restoration, and scheduled maintenance tasks.

## Features

### 1. Server Health Monitoring
- Monitors CPU load.
- Checks memory usage.
- Monitors root disk usage.
- Displays top 5 memory-consuming processes.
- Generates daily health-check logs.

### 2. Automated Backup and Restoration
- Creates timestamped compressed backups (`.tar.gz`).
- Verifies backup archives.
- Removes older backups according to the configured retention policy.
- Records backup results in a log file.

### 3. Scheduled Automation with Cron
Automated tasks are configured using Linux Cron.

| Task                |              Schedule |
|---------------------|-----------------------|
| Server health check | Every 5 minute        |   
| Automated backup    | Every day at 10:00 PM |

### 4. Logging
- Health-check logs: `logs/health-YYYY-MM-DD.log`
- Backup logs: `logs/backup.log`

## Project Structure

```text
linux-automation-toolkit/
├── backup/
├── config/
├── docs/
├── logs/
├── scripts/
│   ├── health-check.sh
│   └── backup.sh
├── test-data/
└── .gitignore
```

## Technologies Used

- Ubuntu Linux
- Bash Scripting
- Cron
- Git
- GitHub
- Tar

## Setup and Usage

Clone the repository:

```bash
git clone https://github.com/Thanuj-g/linux-automation-toolkit.git
cd linux-automation-toolkit
```

Make scripts executable:

```bash
chmod +x scripts/*.sh
```

Run the health check:

```bash
./scripts/health-check.sh
```

Run the backup:

```bash
./scripts/backup.sh
```

## Cron Configuration

View scheduled tasks:

```bash
crontab -l
```

Current schedule:

```cron
*/5 * * * * cd /home/thanuj/devops/projects/linux-automation-toolkit && ./scripts/health-check.sh
0 22 * * * cd /home/thanuj/devops/projects/linux-automation-toolkit && ./scripts/backup.sh
```

## Project Status

- [x] Linux health monitoring
- [x] Automated backup and restoration
- [x] Cron health-check scheduling
- [x] Daily automated backup verification
- [x] GitHub publication

## Author

**Thanuj Hennayake**

GitHub: https://github.com/Thanuj-g
