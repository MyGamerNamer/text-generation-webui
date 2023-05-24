@echo off
set "venv_name=.venv"
if exist "%venv_name%\Scripts\python.exe" (
    echo Virtual environment '%venv_name%' already exists.
) else (
    echo Creating virtual environment '%venv_name%'...
    python -m venv "%venv_name%"
)
echo Activating virtual environment...
call "%venv_name%\Scripts\activate"

python server.py --public-api --verbose --chat --auto-devices --share --extensions elevenlabs_tts api
