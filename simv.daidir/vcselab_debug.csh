#!/bin/csh -f

cd /home/920600899/final_exam

#This ENV is used to avoid overriding current script in next vcselab run 
setenv SNPS_VCSELAB_SCRIPT_NO_OVERRIDE  1

/packages/synopsys/vcs/R-2020.12-SP2-11/linux64/bin/vcselab $* \
    -o \
    simv \
    -nobanner \

cd -

