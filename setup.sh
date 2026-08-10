#!/bin/bash
set -e

echo "============================================================"
echo " Setting up End-to-End Edge-SLAM Environment & Models"
echo "============================================================"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# 1. Run setup in sub-tutorials if present
if [ -f "tutorials/xfeat-ptq/setup.sh" ]; then
    echo "[+] Running XFeat PTQ setup..."
    bash tutorials/xfeat-ptq/setup.sh
fi

if [ -f "tutorials/lighterglue-ptq/setup.sh" ]; then
    echo "[+] Running LighterGlue PTQ setup..."
    bash tutorials/lighterglue-ptq/setup.sh
fi

# 2. Create localized symlinks for top-level notebook execution
mkdir -p weights
mkdir -p sample_data

# Link sample datasets
if [ -d "tutorials/lighterglue-ptq/sample_data/hpatches_sequences" ]; then
    echo "[+] Linking HPatches dataset..."
    ln -sfn "$SCRIPT_DIR/tutorials/lighterglue-ptq/sample_data/hpatches_sequences" sample_data/hpatches_sequences
fi

if [ -d "tutorials/lighterglue-ptq/sample_data/calibration_data" ]; then
    echo "[+] Linking calibration dataset..."
    ln -sfn "$SCRIPT_DIR/tutorials/lighterglue-ptq/sample_data/calibration_data" sample_data/calibration_data
fi

# Copy test images
cp tutorials/lighterglue-ptq/sample_data/indoor_*.jpg sample_data/ 2>/dev/null || true

# Copy SuperPoint pytorch definition
if [ -f "tutorials/lighterglue-ptq/superpoint_pytorch.py" ]; then
    cp tutorials/lighterglue-ptq/superpoint_pytorch.py ./ 2>/dev/null || true
fi

# Ensure SuperPoint weights exist
if [ -f "tutorials/lighterglue-ptq/weights/superpoint_v6_from_tf.pth" ]; then
    cp tutorials/lighterglue-ptq/weights/superpoint_v6_from_tf.pth weights/ 2>/dev/null || true
elif [ ! -f "weights/superpoint_v6_from_tf.pth" ]; then
    echo "[+] Downloading SuperPoint pretrained weights..."
    wget -q --show-progress -O weights/superpoint_v6_from_tf.pth https://raw.githubusercontent.com/magicleap/SuperPointPretrainedNetwork/master/superpoint_v6_from_tf.pth || true
fi

echo "============================================================"
echo " Setup Complete! You can now run end_to_end_edge_slam.ipynb"
echo "============================================================"
