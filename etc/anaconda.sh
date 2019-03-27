# /etc/profile.d/anaconda.sh
# Sets anaconda up for global usage. 
export PATH="/home/anaconda3/bin:$PATH"

__conda_setup="$(CONDA_REPORT_ERRORS=false '/home/anaconda3/bin/conda' shell.bash hook 2> /dev/null)"
if [ $? -eq 0 ]; then
    \eval "$__conda_setup"
else
    if [ -f "/home/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        \export PATH="/home/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
