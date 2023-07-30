python main.py data/ch_man_2/ --workspace trial_ch_man_2_hu_cn/ -O --iters 100000 --asr_model  hubert_cn
cp -r trial_ch_man_2_hu_cn/checkpoints trial_ch_man_2_hu_cn/checkpoints_
python main.py data/ch_man_2/ --workspace trial_ch_man_2_hu_cn/ -O --iters 125000 --finetune_lips --patch_size 32 --asr_model  hubert_cn
python main.py data/ch_man_2/ --workspace trial_ch_man_2_hu_cn/ -O --test --asr_model  hubert_cn
# python main.py data/ch_man_2/ --workspace trial_ch_man_2_hu_cn_torso/ -O --torso --head_ckpt <head>.pth --iters 200000