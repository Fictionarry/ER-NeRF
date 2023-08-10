dataset=obama
workspace=trial_obama
asr_model=deepspeech

python main.py data/$dataset --workspace $workspace -O --iters 100000 --asr_model $asr_model
cp -r $workspace/checkpoints $workspace/checkpoints_
python main.py data/$dataset --workspace $workspace -O --iters 125000 --finetune_lips --patch_size 32 --asr_model $asr_model
python main.py data/$dataset --workspace $workspace -O --test --asr_model $asr_model
# python main.py data/$dataset --workspace $workspace"_torso" -O --torso --head_ckpt ngp.pth --iters 200000