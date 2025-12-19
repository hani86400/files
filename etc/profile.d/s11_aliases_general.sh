export S11_WORK_DIR='/opt/s11_wd'
export S11_DC_DIR='/opt/s11_wd/dc'

alias find_wd="find /opt/s11_wd"
alias find_dc="find /opt/s11_wd/dc"


alias ps10="export PS1='# '"
alias ps11="export PS1='$ '"

alias h='     history'
alias H='     history'
alias hgrep=' history | grep '
alias hmore=' history | more '
alias ll='ls -lAtrF'
shopt -s histappend 
export PROMPT_COMMAND='history -a ; history -n' #export history ; import history
export HISTCONTROL=ignoreboth 