dataset=ch_woman
workspace=trial_ch_woman_hu_cn
asr_model=hubert_cn
python main.py data/$dataset --workspace $workspace -O --iters 100000 --asr_model $asr_model
cp -r $workspace/checkpoints $workspace/checkpoints_
python main.py data/$dataset --workspace $workspace -O --iters 125000 --finetune_lips --patch_size 32 --asr_model $asr_model
python main.py data/$dataset --workspace $workspace -O --test --asr_model $asr_model
# python main.py data/ch_man --workspace trial_ch_man_triplane_torso/ -O --torso --head_ckpt <head>.pth --iters 200000