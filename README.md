# Simple bash script for MacOS to run DeepSeek AI model locally

This is a simple script that you can execute on your MacOS based laptop to run and access **DeepSeek R1** locally with minimum effort. The script automates the deployment of all of the necessary dependency packages, and provide a simple start/stop method to experiment with AI model for a novice user.


# Getting started

Copy the the .sh script to your disk
```
git clone https://github.com/imanassypov/deepseek_run_macos.git
Cloning into 'deepseek_run_macos'...
remote: Enumerating objects: 10, done.
remote: Counting objects: 100% (10/10), done.
remote: Compressing objects: 100% (8/8), done.
remote: Total 10 (delta 0), reused 10 (delta 0), pack-reused 0 (from 0)
Receiving objects: 100% (10/10), done.
```

Enable executable flag for the script
```
cd deepseek_run_macos
sudo chmod +x deepseek_run_macos.sh
```

## What the script does

The script will ensure that your PC has the required dependencies installed:

- Homebrew package manager [https://docs.brew.sh/Installation]
- Docker Desktop container environment [https://www.docker.com/products/docker-desktop/]
- Ollama, local environment for running LLM [https://ollama.com/]
- Self-hosted AI Interface frontend [https://openwebui.com/]
- DeepSeek R1 open-source model [https://github.com/deepseek-ai/DeepSeek-R1] 


## How to operate the script

The script has the following simple flags:

```
./deepseek_run_macos.sh
Usage: ./deepseek_run_macos.sh --start <model_size> | --stop
Model sizes: 1.5b, 7b, 8b, 14b, 32b, 70b
```

## Starting DeepSeek R1 model locally
From Terminal App on your MacOS, start the model - in this example the smallest 1.5b parameter
```
./deepseek_run_macos.sh --start 1
.5b
==================================================
Starting services with model size: 1.5b...
==================================================
==================================================
Homebrew is already installed.
==================================================
==================================================
Updating Homebrew...
==================================================
==> Updating Homebrew...
Already up-to-date.
==================================================
Docker Desktop is already installed.
==================================================
==================================================
Checking if Docker Desktop is running...
==================================================
==================================================
Docker Desktop is already running.
==================================================
==================================================
Checking if Ollama model 1.5b is already running...
==================================================
==================================================
Starting Ollama with the deepseek-r1:1.5b model in a separate process...
==================================================
==================================================
Open-WebUI container is already running.
==================================================
==================================================
Opening browser to Open-WebUI and Ollama...
==================================================
==================================================
All tasks completed. Services are up and running with model size: 1.5b.
==================================================
```

The script will open a browser with two tabs, one which should show Ollama status, and this tab can be closed:
```
Ollama is running
```

The second tab should open the Open-WebUI tab which will require you to register and login before you can interface with the local model

## Stopping the model

To spin-down the local environment, execute the script with the --stop flag:
```
./deepseek_run_macos.sh --stop
==================================================
Stopping services...
==================================================
==================================================
Checking for running Ollama models...
==================================================
==================================================
Stopping Ollama model: deepseek-r1:1.5b
==================================================
==================================================
Stopping and removing Open-WebUI Docker container...
==================================================
open-webui
open-webui
==================================================
All services have been stopped.
==================================================
```
