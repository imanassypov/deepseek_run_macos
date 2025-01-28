#!/bin/bash

# Function to print messages
print_message() {
    echo "=================================================="
    echo "$1"
    echo "=================================================="
}

# Function to stop services
stop_services() {
    print_message "Stopping services..."

    # Stop all running Ollama models
    if command -v ollama &>/dev/null; then
        print_message "Checking for running Ollama models..."
        MODELS=$(ollama ps | awk 'NR>1 {print $1}') # Skip the header row and get model names
        if [[ -n "$MODELS" ]]; then
            for MODEL in $MODELS; do
                print_message "Stopping Ollama model: $MODEL"
                ollama stop "$MODEL"
            done
        else
            print_message "No Ollama models are currently running."
        fi
    else
        print_message "Ollama is not installed or not found."
    fi

    # Stop and remove Open-WebUI Docker container
    if docker ps -a --filter "name=open-webui" | grep -q open-webui; then
        print_message "Stopping and removing Open-WebUI Docker container..."
        docker stop open-webui
        docker rm open-webui
    else
        print_message "Open-WebUI container is not running."
    fi

    print_message "All services have been stopped."
    exit 0
}

# Ensure the script runs on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    echo "This script is intended for macOS only."
    exit 1
fi

# Handle arguments
if [[ "$1" == "--stop" ]]; then
    stop_services
elif [[ "$1" != "--start" ]]; then
    echo "Usage: $0 --start <model_size> | --stop"
    echo "Model sizes: 1.5b, 7b, 8b, 14b, 32b, 70b"
    exit 1
fi

# Check for model size
MODEL_SIZE="$2"
VALID_MODELS=("1.5b" "7b" "8b" "14b" "32b" "70b")
if [[ "$1" == "--start" && ! " ${VALID_MODELS[*]} " =~ " $MODEL_SIZE " ]]; then
    echo "Invalid model size. Please specify one of the following: ${VALID_MODELS[*]}"
    exit 1
fi

# Start services
print_message "Starting services with model size: $MODEL_SIZE..."

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
    print_message "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    print_message "Homebrew is already installed."
fi

# Update and upgrade Homebrew
print_message "Updating Homebrew..."
brew update && brew upgrade

# Install Docker Desktop if not installed
if ! command -v docker &>/dev/null; then
    print_message "Docker Desktop not found. Installing Docker Desktop..."
    brew install --cask docker
else
    print_message "Docker Desktop is already installed."
fi

# Check if Docker Desktop is running
print_message "Checking if Docker Desktop is running..."
if ! pgrep -f "Docker Desktop" &>/dev/null; then
    print_message "Docker Desktop is not running. Starting Docker Desktop..."
    open -a Docker
    sleep 10 # Give Docker time to start
    # Wait until Docker becomes responsive
    while ! docker info &>/dev/null; do
        print_message "Waiting for Docker to start..."
        sleep 5
    done
    print_message "Docker Desktop is now running."
else
    print_message "Docker Desktop is already running."
fi

# Check if the specified Ollama model is already running
print_message "Checking if Ollama model $MODEL_SIZE is already running..."
if ollama ps | grep -q "$MODEL_SIZE"; then
    print_message "Ollama model $MODEL_SIZE is already running."
else
    print_message "Starting Ollama with the deepseek-r1:$MODEL_SIZE model in a separate process..."
    nohup ollama run deepseek-r1:$MODEL_SIZE > ollama.log 2>&1 &
fi

# Check if Open-WebUI container is running
if ! docker ps --filter "name=open-webui" --filter "status=running" | grep -q open-webui; then
    print_message "Open-WebUI container is not running. Pulling and starting the container..."
    # Pull the latest Open-WebUI image
    docker pull ghcr.io/open-webui/open-webui:main
    
    # Start the Open-WebUI container
    docker run -d -p 9783:8080 -v open-webui:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main
    
    print_message "Open-WebUI container started successfully."
else
    print_message "Open-WebUI container is already running."
fi

# Open the required ports
print_message "Opening browser to Open-WebUI and Ollama..."
open "http://localhost:9783" # Open-WebUI
open "http://localhost:11434" # Ollama

# Confirmation message
print_message "All tasks completed. Services are up and running with model size: $MODEL_SIZE."