import io
from pydub import AudioSegment
import gradio as gr
import speech_recognition as sr

from modules import shared

input_hijack = {
    'state': False,
    'value': ["", ""]
}


def do_stt(audio):
    transcription = ""
    r = sr.Recognizer()

    # Convert to AudioData
    audio_data = sr.AudioData(sample_rate=audio[0], frame_data=audio[1], sample_width=4)

    try:
        transcription = r.recognize_whisper(audio_data, language="english", model="base.en")
    except sr.UnknownValueError:
        print("Whisper could not understand audio")
    except sr.RequestError as e:
        print("Could not request results from Whisper", e)

    return transcription


def auto_transcribe(audio, auto_submit):
    if audio is None:
        return "", ""

    transcription = do_stt(audio)
    if auto_submit:
        input_hijack.update({"state": True, "value": [transcription, transcription]})

    return transcription, None

def ogg_bytes_to_audio_data(ogg_bytes):
    ogg_audio = AudioSegment.from_ogg(io.BytesIO(ogg_bytes))
    wav_audio = ogg_audio.export(format="wav")
    wav_audio.seek(0)
    r = sr.Recognizer()
    with sr.AudioFile(wav_audio) as source:
        audio_data = r.record(source)
    return audio_data

def do_stt_api(audio):
    transcription = ""
    r = sr.Recognizer()
    try:
        transcription = r.recognize_whisper(audio, language="english", model="base.en")
    except sr.UnknownValueError:
        print("Whisper could not understand audio")
    except sr.RequestError as e:
        print("Could not request results from Whisper", e)
    return transcription

def api_transcribe(audio_bytes, auto_submit):
    if audio_bytes is None:
        return "", ""

    audio = ogg_bytes_to_audio_data(audio_bytes)
    transcription = do_stt_api(audio)
    if auto_submit:
        input_hijack.update({"state": True, "value": [transcription, transcription]})

    return transcription, None


def ui():
    with gr.Row():
        audio = gr.Audio(source="microphone")
        auto_submit = gr.Checkbox(label='Submit the transcribed audio automatically', value=True)

    audio.change(
        auto_transcribe, [audio, auto_submit], [shared.gradio['textbox'], audio]).then(
        None, auto_submit, None, _js="(check) => {if (check) { document.getElementById('Generate').click() }}")
