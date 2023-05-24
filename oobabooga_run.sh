#!/bin/bash

venv_name=".venv"
if [ -d "$venv_name" ]; then
    echo "Virtual environment '$venv_name' already exists."
else
    echo "Creating virtual environment '$venv_name'..."
    python3 -m venv "$venv_name"
fi
echo "Activating virtual environment..."
source "$venv_name/bin/activate"

python server.py --public-api --verbose --chat --auto-devices --share --extensions elevenlabs_tts api
