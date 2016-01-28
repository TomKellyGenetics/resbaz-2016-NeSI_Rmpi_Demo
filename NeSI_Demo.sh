pwd
cd ~/Downloads/ResBaz2016/NeSI_Demo
cat ~/.ssh/config
ssh pan

cd /projects/uoo00010
mkdir NeSI_Demo
exit

scp *R pan:/projects/uoo00010/NeSI_Demo
scp -c arcfour * pan:/projects/uoo00010/NeSI_Demo

ssh pan
cd /projects/uoo00010/NeSI_Demo
sbatch NeSI_Demo_parallel_test.sl
squeue -u simon.kelly


scp *R pan:/projects/uoo00010/NeSI_Demo
scp *sl pan:/projects/uoo00010/NeSI_Demo

ssh pan
cd /projects/uoo00010/NeSI_Demo
sbatch NeSI_Demo_parallel_full.sl
squeue -u simon.kelly

scancel XXXXXX
cat slurm-XXXXXX.out
