
#pip install -U gradio==3.28.3
pip install -U flask_cloudflared
pip install -r requirements.txt
pip install -r ./extensions/elevenlabs_tts/requirements.txt

mkdir ./repositories
cd ./repositories
git clone https://github.com/oobabooga/GPTQ-for-LLaMa.git
cd GPTQ-for-LLaMa
python setup_cuda.py install

apt-get -y install -qq aria2 # needs to work with other package managers than
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/pyg-13b-4bit-128g/raw/main/config.json                -d /content/text-generation-webui/models/pyg-13b-4bit-128g -o config.json
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/pyg-13b-4bit-128g/raw/main/generation_config.json     -d /content/text-generation-webui/models/pyg-13b-4bit-128g -o generation_config.json
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/pyg-13b-4bit-128g/raw/main/special_tokens_map.json    -d /content/text-generation-webui/models/pyg-13b-4bit-128g -o special_tokens_map.json
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/pyg-13b-4bit-128g/resolve/main/tokenizer.model        -d /content/text-generation-webui/models/pyg-13b-4bit-128g -o tokenizer.model
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/pyg-13b-4bit-128g/raw/main/tokenizer_config.json      -d /content/text-generation-webui/models/pyg-13b-4bit-128g -o tokenizer_config.json
aria2c --console-log-level=error -c -x 16 -s 16 -k 1M https://huggingface.co/4bit/pyg-13b-4bit-128g/resolve/main/4bit-128g.safetensors  -d /content/text-generation-webui/models/pyg-13b-4bit-128g -o 4bit-128g.safetensors

cd /content/text-generation-webui
python server.py --wbits 4 --groupsize 128 --public-api --verbose --chat --auto-devices --share --extensions elevenlabs_tts api --model_type llama