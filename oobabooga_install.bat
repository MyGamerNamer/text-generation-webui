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

pip install flask_cloudflared
pip install -r .\requirements.txt
pip install -r .\extensions\elevenlabs_tts\requirements.txt

echo Successfully installed API, ready to start using oobabooga_run.bat
