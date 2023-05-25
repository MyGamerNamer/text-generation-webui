#!/bin/bash

# Note: gcc (GNU C/CPP compiler) and nvcc (Nvidia cuda C/CPP compiler) must be available on system path

venv_name=".venv"
if [ -f "${venv_name}/bin/python" ]; then
    echo "Virtual environment '${venv_name}' already exists."
else
    echo "Creating virtual environment '${venv_name}'..."
    python3 -m venv "${venv_name}"
fi
echo "Activating virtual environment..."
source "${venv_name}/bin/activate"

# pip install torch torchvision torchaudio -f https://download.pytorch.org/whl/torch_stable.html
pip install flask_cloudflared
pip install https://github.com/jllllll/bitsandbytes-windows-webui/raw/main/bitsandbytes-0.38.1-py3-none-any.whl
pip install torch==2.0.0+cu118 torchvision torchaudio -f https://download.pytorch.org/whl/torch_stable.html
pip install ninja gitpython
pip install -r ./requirements.txt
pip install -r ./extensions/elevenlabs_tts/requirements.txt
pip install -r ./extensions/whisper_stt/requirements.txt

mkdir -p ./repositories
git clone https://github.com/oobabooga/GPTQ-for-LLaMa.git ./repositories/GPTQ-for-LLaMa
cd ./repositories/GPTQ-for-LLaMa
python3 ./setup_cuda.py install

echo "Successfully installed API, ready to start using oobabooga_run.sh"
