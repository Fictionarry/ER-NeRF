python main.py data/ch_man_2/ --workspace trial_ch_man_2_triplane/ -O --iters 100000 --asr_model  hubert
cp -r trial_ch_man_2_triplane/checkpoints trial_ch_man_2_triplane/checkpoints_
python main.py data/ch_man_2/ --workspace trial_ch_man_2_triplane/ -O --iters 125000 --finetune_lips --patch_size 32 --asr_model  hubert
python main.py data/ch_man_2/ --workspace trial_ch_man_2_triplane/ -O --test --asr_model  hubert
# python main.py data/ch_man_2/ --workspace trial_ch_man_2_triplane_torso/ -O --torso --head_ckpt <head>.pth --iters 200000