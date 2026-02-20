# Service Scripts 

A collections of shell scipts to manage the full lifecycle of a service - from initial setup to running and stopping it.

---

## Scripts Overview

| Order | Script                       | Description                                                                                                    |
| ----- | ---------------------------- | -------------------------------------------------------------------------------------------------------------- |
| 1     | `create-service.sh`          | Creates the log directory, log file, and app shell script                                                      |
| 2     | `register-enable-service.sh` | Registers the service with systemd and enables it to start on boot (Input from user)                           |
| 3     | `start-service.sh`           | Starts the service (service name= input from user)                                                             |
| 4     | `stop-service.sh`            | Stops the service  (service name= input from user)                                                             |
| 4     | `clean-up.sh`                | Cleanup process like, delete service, delete corersponding log file and folder (service name= input from user) |


## Prerequisites

- `sudo` privileges on the machine
- `systemd`-based Linux OS (Ubuntu, Debian, RHEL, CentOS, etc.)
- `tree` package installed (used for output display in `create-service.sh`)
  ```bash
  sudo apt install tree      # Debian/Ubuntu
  ```
---

## Step-by-Step Usage

### Step 1 - Create Service

Sets up the service structure: log directory, log file, and the application shell script.

```bash
chmod +x create-service.sh
./create-service.sh
```
You will be prompted to enter a service name:

```
Please provide the service name: myapp
```

**What gets created:**

```
/var/log/myapp/
└── myapp.log

/usr/local/bin/
└── myapp.sh
```
---

### Step 2 — Register & Enable Service

Registers the service with `systemd` and enables it to automatically start on system boot.

```bash
chmod +x register-enable-service.sh
./register-enable-service.sh
```

After this step the service will have a `systemd` unit file and will be enabled — but not yet running. Proceed to Step 3 to start it.

---

### Step 3 — Start Service

Starts the service and begins execution.

```bash
chmod +x start-service.sh
./start-service.sh
```
To verify the service is running:

```bash
systemctl status 
```
To watch live log output:

```bash
tail -f /var/log//.log
```
---

### Step 4 — Stop Service

Gracefully stops the running service.

```bash
chmod +x stop-service.sh
./stop-service.sh
```
To confirm the service has stopped:

```bash
systemctl status 
```
---

### Cleanup process

Cleanup the process like, stop service, disable service, remove service (from systemd), remove shell and log file.

```bash
chmod +x stop-service.sh
./cleanup.sh
```

```bash
Given command will be executed during cleanup:

  sudo systemctl stop $SERVICE_NAME
  
  sudo systemctl disable $SERVICE_NAME

  sudo rm -f /etc/systemd/system/$SERVICE_NAME.service

  sudo systemctl daemon-reload

  sudo systemctl reset-failed

  sudo rm -f /usr/local/bin/$SERVICE_NAME.sh

  sudo rm -rf /var/log/$SERVICE_NAME
```

---

## THINGS TO REMEMBER 

- Use a consistent service name accross all scripts.
- `register-enable-service.sh` must be run before `start-service.sh`, as systemd needs the unit file to manage the service.