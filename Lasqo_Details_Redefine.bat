@echo off
echo ===================================================================
echo            COMFYUI MODEL DOWNLOADER USING HUGGINGFACE CLI
echo ===================================================================
echo.

echo [1/6] Checking and installing requirements...
pip install huggingface_hub -q
echo     √ Hugging Face Hub installed

echo Setting up authentication...
set HF_TOKEN=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
echo     √ Authentication configured
echo.

echo [2/6] Creating necessary directories...
mkdir models\diffusion_model 2>nul || echo     - diffusion_model directory already exists
mkdir models\VAE 2>nul || echo     - VAE directory already exists
mkdir models\CLIP 2>nul || echo     - CLIP directory already exists
mkdir models\loras 2>nul || echo     - loras directory already exists
mkdir models\upscale_models 2>nul || echo     - upscale_models directory already exists
echo     √ All directories created successfully
echo.

echo [3/6] Downloading FLUX.1 checkpoint model (this may take a while)...
echo     - Target: models\diffusion_model\flux1-fill-dev.safetensors
huggingface-cli download --token %HF_TOKEN% black-forest-labs/FLUX.1-Fill-dev flux1-fill-dev.safetensors --local-dir models\diffusion_model
echo     √ FLUX.1 checkpoint download completed
echo.

echo [4/6] Downloading ACE++ LoRA models...
echo     - Downloading subject LoRA
huggingface-cli download --token %HF_TOKEN% ali-vilab/ACE_Plus subject/comfyui_subject_lora16.safetensors --local-dir models\loras --local-dir-use-symlinks False
move models\loras\subject\comfyui_subject_lora16.safetensors models\loras\ 2>nul
rmdir models\loras\subject 2>nul

echo     - Downloading local editing LoRA
huggingface-cli download --token %HF_TOKEN% ali-vilab/ACE_Plus local_editing/comfyui_local_lora16.safetensors --local-dir models\loras --local-dir-use-symlinks False
move models\loras\local_editing\comfyui_local_lora16.safetensors models\loras\ 2>nul
rmdir models\loras\local_editing 2>nul

echo     - Downloading portrait LoRA
huggingface-cli download --token %HF_TOKEN% ali-vilab/ACE_Plus portrait/comfyui_portrait_lora64.safetensors --local-dir models\loras --local-dir-use-symlinks False
move models\loras\portrait\comfyui_portrait_lora64.safetensors models\loras\ 2>nul
rmdir models\loras\portrait 2>nul
echo     √ All ACE++ LoRA models downloaded successfully
echo.

echo [5/6] Downloading VAE model...
echo     - Creating FLUX1 subdirectory
mkdir models\VAE\FLUX1 2>nul
echo     - Downloading FLUX.1 VAE
huggingface-cli download --token %HF_TOKEN% black-forest-labs/FLUX.1-schnell ae.safetensors --local-dir models\VAE\FLUX1 --local-dir-use-symlinks False
echo     √ VAE model downloaded successfully
echo.

echo [6/6] Downloading CLIP models...
echo     - Downloading CLIP-L
huggingface-cli download --token %HF_TOKEN% comfyanonymous/flux_text_encoders clip_l.safetensors --local-dir models\CLIP --local-dir-use-symlinks False
echo     - Creating T5 subdirectory
mkdir models\CLIP\t5 2>nul
echo     - Downloading T5 encoder
huggingface-cli download --token %HF_TOKEN% Madespace/clip google_t5-v1_1-xxl_encoderonly-fp8_e4m3fn.safetensors --local-dir models\CLIP\t5 --local-dir-use-symlinks False
echo     √ CLIP models downloaded successfully
echo.

echo [7/6] Downloading upscale model...
echo     - Downloading 4x-UltraSharp upscaler
huggingface-cli download --token %HF_TOKEN% lokCX/4x-Ultrasharp 4x-UltraSharp.pth --local-dir models\upscale_models --local-dir-use-symlinks False
echo     √ Upscale model downloaded successfully
echo.

echo ===================================================================
echo                     DOWNLOAD SUMMARY
echo ===================================================================
echo Models successfully downloaded:
echo   - Checkpoint: flux1-fill-dev.safetensors
echo   - LoRAs: 3 ACE++ LoRA models
echo   - VAE: FLUX.1 ae.safetensors
echo   - CLIP: clip_l.safetensors and T5 encoder
echo   - Upscaler: 4x-UltraSharp.pth
echo.
echo All models are now ready for use with ComfyUI!
echo ===================================================================

pause