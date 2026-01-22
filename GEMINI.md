# FunClip Project Gemini Configuration

## Project Overview

FunClip is a Python-based, open-source video clipping tool that leverages speech recognition to automate the process of editing videos. It provides a user-friendly interface using Gradio, as well as a command-line interface for more advanced users. The core functionality is built around the FunASR library for speech-to-text conversion and MoviePy for video manipulation.

### Key Features:

- **Automated Video Clipping:** Clips videos based on recognized speech.
- **LLM-Based Smart Clipping:** Utilizes Large Language Models (LLMs) to intelligently select and clip video segments.
- **Speaker Recognition:** Can identify and clip segments based on speaker diarization.
- **Hotword Customization:** Allows users to specify custom hotwords to improve recognition accuracy.
- **Gradio Interface:** Offers an intuitive web-based UI for easy interaction.
- **Command-Line Interface:** Provides a powerful CLI for batch processing and integration with other tools.
- **Subtitle Generation:** Automatically generates SRT subtitle files for both the full video and the clipped segments.

### Main Technologies:

- **Backend:** Python
- **Speech Recognition:** FunASR
- **Video Processing:** MoviePy, ffmpeg, ImageMagick
- **User Interface:** Gradio
- **LLM Integration:** OpenAI GPT, Qwen, G4F

## Building and Running

### Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/alibaba-damo-academy/FunClip.git
   cd FunClip
   ```
2. **Install Python dependencies:**
   ```bash
   pip install -r requirements.txt
   ```
3. **Install Optional Dependencies (for subtitles):**
   - **ffmpeg and ImageMagick:** These are required for embedding subtitles into the video.
     - **Ubuntu:**
       ```bash
       apt-get -y update && apt-get -y install ffmpeg imagemagick
       sed -i 's/none/read,write/g' /etc/ImageMagick-6/policy.xml
       ```
     - **macOS:**
       ```bash
       brew install imagemagick
       sed -i 's/none/read,write/g' /usr/local/Cellar/imagemagick/7.1.1-8_1/etc/ImageMagick-7/policy.xml
       ```
     - **Windows:** Download and install from the [ImageMagick website](https://imagemagick.org/script/download.php#windows).
   - **Font:** Download a font file for the subtitles:
     ```bash
     wget https://isv-data.oss-cn-hangzhou.aliyuncs.com/ics/MaaS/ClipVideo/STHeitiMedium.ttc -O font/STHeitiMedium.ttc
     ```

### Running the Application

FunClip can be run in two modes: as a Gradio web application or as a command-line tool.

#### Gradio Web Application

To launch the Gradio interface, run the following command:

```bash
python funclip/launch.py
```

This will start a local web server, and you can access the application by navigating to `http://localhost:7860` in your web browser.

The `launch.py` script accepts the following command-line arguments:
- `-l` or `--lang`: Language ('zh' for Chinese, 'en' for English).
- `-s` or `--share`: Create a public Gradio share link.
- `-p` or `--port`: Set the port number.
- `--listen`: Listen on all network interfaces.

#### Command-Line Interface

The command-line interface is handled by `funclip/videoclipper.py` and operates in two stages:

1. **Stage 1: Recognition**
   - This stage performs speech recognition on the input video and saves the results.
   ```bash
   python funclip/videoclipper.py --stage 1 \
                         --file <path_to_video> \
                         --output_dir ./output
   ```

2. **Stage 2: Clipping**
   - This stage clips the video based on the recognition results from stage 1.
   ```bash
   python funclip/videoclipper.py --stage 2 \
                         --file <path_to_video> \
                         --output_dir ./output \
                         --dest_text "<text_to_clip>"
   ```

## Development Conventions

### Project Structure

- `funclip/`: Main source code directory.
  - `launch.py`: Entry point for the Gradio application.
  - `videoclipper.py`: Core logic for video clipping and command-line interface.
  - `llm/`: Modules for interacting with Large Language Models.
  - `utils/`: Utility functions for subtitle generation, argument parsing, etc.
- `requirements.txt`: Python dependencies.
- `Dockerfile`: For building a Docker image of the application.
- `docs/`: Documentation and images.
- `font/`: Font files for subtitles.
- `input/`: Default input directory.
- `output/`: Default output directory.

### Dependencies

The project's Python dependencies are listed in `requirements.txt`. Key libraries include:

- `funasr`: For speech recognition.
- `moviepy`: For video editing.
- `gradio`: For the web UI.
- `openai`, `g4f`, `dashscope`: For LLM integration.
- `librosa`, `soundfile`: For audio processing.
