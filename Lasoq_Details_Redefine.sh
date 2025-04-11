#!/bin/bash

echo "==================================================================="
echo "            COMFYUI MODEL DOWNLOADER USING HUGGINGFACE CLI"
echo "==================================================================="
echo ""

echo "[1/6] Checking and installing requirements..."
pip install huggingface_hub -q
echo "    √ Hugging Face Hub installed"

echo "Setting up authentication..."
export HF_TOKEN=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
echo "    √ Authentication configured"
echo ""

echo "[2/6] Creating necessary directories..."
mkdir -p models/diffusion_modelss 2>/dev/null || echo "    - diffusion_models directory already exists"
mkdir -p models/vae 2>/dev/null || echo "    - vae directory already exists"
mkdir -p models/clip 2>/dev/null || echo "    - CLIP directory already exists"
mkdir -p models/loras 2>/dev/null || echo "    - loras directory already exists"
mkdir -p models/upscale_models 2>/dev/null || echo "    - upscale_models directory already exists"
echo "    √ All directories created successfully"
echo ""

echo "[3/6] Downloading FLUX.1 checkpoint model (this may take a while)..."
echo "    - Target: models/diffusion_models/flux1-fill-dev.safetensors"
huggingface-cli download --token $HF_TOKEN black-forest-labs/FLUX.1-Fill-dev flux1-fill-dev.safetensors --local-dir models/diffusion_models
echo "    √ FLUX.1 checkpoint download completed"
echo ""

echo "[4/6] Downloading ACE++ LoRA models..."
echo "    - Downloading subject LoRA"
huggingface-cli download --token $HF_TOKEN ali-vilab/ACE_Plus subject/comfyui_subject_lora16.safetensors --local-dir models/loras --local-dir-use-symlinks False
mv models/loras/subject/comfyui_subject_lora16.safetensors models/loras/ 2>/dev/null
rmdir models/loras/subject 2>/dev/null

echo "    - Downloading local editing LoRA"
huggingface-cli download --token $HF_TOKEN ali-vilab/ACE_Plus local_editing/comfyui_local_lora16.safetensors --local-dir models/loras --local-dir-use-symlinks False
mv models/loras/local_editing/comfyui_local_lora16.safetensors models/loras/ 2>/dev/null
rmdir models/loras/local_editing 2>/dev/null

echo "    - Downloading portrait LoRA"
huggingface-cli download --token $HF_TOKEN ali-vilab/ACE_Plus portrait/comfyui_portrait_lora64.safetensors --local-dir models/loras --local-dir-use-symlinks False
mv models/loras/portrait/comfyui_portrait_lora64.safetensors models/loras/ 2>/dev/null
rmdir models/loras/portrait 2>/dev/null
echo "    √ All ACE++ LoRA models downloaded successfully"
echo ""

echo "[5/6] Downloading VAE model..."
echo "    - Creating FLUX1 subdirectory"
mkdir -p models/vae/FLUX1 2>/dev/null
echo "    - Downloading FLUX.1 VAE"
huggingface-cli download --token $HF_TOKEN black-forest-labs/FLUX.1-schnell ae.safetensors --local-dir models/vae/FLUX1 --local-dir-use-symlinks False
echo "    √ VAE model downloaded successfully"
echo ""

echo "[6/6] Downloading CLIP models..."
echo "    - Downloading CLIP-L"
huggingface-cli download --token $HF_TOKEN comfyanonymous/flux_text_encoders clip_l.safetensors --local-dir models/clip --local-dir-use-symlinks False
echo "    - Creating T5 subdirectory"
mkdir -p models/clip/t5 2>/dev/null
echo "    - Downloading T5 encoder"
huggingface-cli download --token $HF_TOKEN Madespace/clip google_t5-v1_1-xxl_encoderonly-fp8_e4m3fn.safetensors --local-dir models/clip/t5 --local-dir-use-symlinks False
echo "    √ CLIP models downloaded successfully"
echo ""

echo "[7/6] Downloading upscale model..."
echo "    - Downloading 4x-UltraSharp upscaler"
huggingface-cli download --token $HF_TOKEN lokCX/4x-Ultrasharp 4x-UltraSharp.pth --local-dir models/upscale_models --local-dir-use-symlinks False
echo "    √ Upscale model downloaded successfully"
echo ""

echo "==================================================================="
echo "                     DOWNLOAD SUMMARY"
echo "==================================================================="
echo "Models successfully downloaded:"
echo "  - Checkpoint: flux1-fill-dev.safetensors"
echo "  - LoRAs: 3 ACE++ LoRA models"
echo "  - VAE: FLUX.1 ae.safetensors"
echo "  - CLIP: clip_l.safetensors and T5 encoder"
echo "  - Upscaler: 4x-UltraSharp.pth"
echo ""
echo "All models are now ready for use with ComfyUI!"
echo "==================================================================="

read -p "Press Enter to continue..."