# ER-NeRF

This is the official repo for our ICCV2023 paper **Efficient Region-Aware Neural Radiance Fields for High-Fidelity Talking Portrait Synthesis**.

![image](assets/main.png)

## Install

Tested on Ubuntu 18.04, Pytorch 1.12 and CUDA 11.3.

### Install dependency

```bash
conda install pytorch==1.12.1 cudatoolkit=11.3 -c pytorch
pip install -r requirements.txt
pip install "git+https://github.com/facebookresearch/pytorch3d.git"
pip install tensorflow-gpu==2.8.0
```

### Preparation

- Prepare face-parsing model.

  ```bash
  wget https://github.com/YudongGuo/AD-NeRF/blob/master/data_util/face_parsing/79999_iter.pth?raw=true -O data_utils/face_parsing/79999_iter.pth
  ```

- Prepare the 3DMM model for head pose estimation.

  ```bash
  wget https://github.com/YudongGuo/AD-NeRF/blob/master/data_util/face_tracking/3DMM/exp_info.npy?raw=true -O data_utils/face_tracking/3DMM/exp_info.npy
  wget https://github.com/YudongGuo/AD-NeRF/blob/master/data_util/face_tracking/3DMM/keys_info.npy?raw=true -O data_utils/face_tracking/3DMM/keys_info.npy
  wget https://github.com/YudongGuo/AD-NeRF/blob/master/data_util/face_tracking/3DMM/sub_mesh.obj?raw=true -O data_utils/face_tracking/3DMM/sub_mesh.obj
  wget https://github.com/YudongGuo/AD-NeRF/blob/master/data_util/face_tracking/3DMM/topology_info.npy?raw=true -O data_utils/face_tracking/3DMM/topology_info.npy
  ```

- Download 3DMM model from [Basel Face Model 2009](https://faces.dmi.unibas.ch/bfm/main.php?nav=1-1-0&id=details):

  ```
  cp 01_MorphableModel.mat data_util/face_tracking/3DMM/
  cd data_util/face_tracking
  python convert_BFM.py
  ```

## Datasets and pretrained models

We get the experiment videos mainly from [DFRF](https://github.com/sstzal/DFRF) and YouTube. Due to copyright restrictions, we can't distribute them. You can download these videos and crop them by youself. Here is an example training video (Obama) from AD-NeRF with the resolution of 450x450. 

```
mkdir -p data/obama
wget https://github.com/YudongGuo/AD-NeRF/blob/master/dataset/vids/Obama.mp4?raw=true -O data/obama/obama.mp4
```

We also provide pretrained checkpoints on the Obama video clip. After completing the data pre-processing step, you can [download](https://github.com/Fictionarry/ER-NeRF/releases/tag/ckpt) and test them by:

```bash
python main.py data/obama/ --workspace trial_obama/ -O --test --ckpt trial_obama/checkpoints/ngp.pth   # head
python main.py data/obama/ --workspace trial_obama/ -O --test --torso --ckpt trial_obama_torso/checkpoints/ngp.pth   # head+torso
```

The test results should be about:

| setting    | PSNR   | LPIPS  | LMD   |
| ---------- | ------ | ------ | ----- |
| head       | 35.607 | 0.0178 | 2.525 |
| head+torso | 26.594 | 0.0446 | 2.550 |

## Usage

### Pre-processing Custom Training Video

* Put training video under `data/<ID>/<ID>.mp4`.

  The video **must be 25FPS, with all frames containing the talking person**. 
  The resolution should be about 512x512, and duration about 1-5 min.

* Run script to process the video. (may take several hours)

  ```bash
  python data_utils/process.py data/<ID>/<ID>.mp4
  ```

### Audio Pre-process

In our paper, we use DeepSpeech features for evaluation:

```bash
python data_utils/deepspeech_features/extract_ds_features.py --input data/<name>.wav # save to data/<name>.npy
```

You can also try to extract audio features via Wav2Vec like [RAD-NeRF](https://github.com/ashawkey/RAD-NeRF) by:

```bash
python nerf/asr.py --wav data/<name>.wav --save_feats # save to data/<name>_eo.npy
```

### Train

First time running will take some time to compile the CUDA extensions.

```bash
# train (head and lpips finetune)
python main.py data/obama/ --workspace trial_obama/ -O --iters 100000
python main.py data/obama/ --workspace trial_obama/ -O --iters 125000 --finetune_lips --patch_size 32

# train (torso)
# <head>.pth should be the latest checkpoint in trial_obama
python main.py data/obama/ --workspace trial_obama_torso/ -O --torso --head_ckpt <head>.pth --iters 200000
```

### Test

```bash
# test on the test split
python main.py data/obama/ --workspace trial_obama/ -O --test # only render the head and use GT image for torso
python main.py data/obama/ --workspace trial_obama_torso/ -O --torso --test # render both head and torso
```

### Inference with target audio

```bash
python main.py data/obama/ --workspace trial_obama_torso/ -O --torso --test --test_train --aud data/<audio>.npy
```

## Citation

Cite as below if you find this repository is helpful to your project:

```
@article{li2023ernerf,
  title={Efficient Region-Aware Neural Radiance Fields for High-Fidelity Talking Portrait Synthesis},
  author={Li, Jiahe and Zhang, Jiawei and Bai, Xiao and Zhou, Jun and Gu, Lin},
  journal={},
  year={2023}
}
```

## Acknowledgement

This code is developed based on [RAD-NeRF](https://github.com/ashawkey/RAD-NeRF), [DFRF](https://github.com/sstzal/DFRF) and [AD-NeRF](https://github.com/YudongGuo/AD-NeRF).  Thanks for these great projects.
