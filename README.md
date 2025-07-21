### PDC Docker Test

This repository contains Docker images with various PDC configurations, which can be used to test particular versions of the PDC code.

## List of Configurations Tested

### 1. Stable Branch
- Multithreading: Enabled / Disabled
- Cache: Enabled / Disabled
- Profiling: Enabled / Disabled
- Timing: Enabled / Disabled

### 2. Develop Branch
- Multithreading: Enabled / Disabled
- Cache: Enabled / Disabled
- Profiling: Enabled / Disabled
- Timing: Enabled / Disabled

### 3. Custom Commit Version
- Multithreading: Enabled / Disabled
- Cache: Enabled / Disabled
- Profiling: Enabled / Disabled
- Timing: Enabled / Disabled

### Installing Docker

```bash
sudo apt update
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo docker run hello-world
```
