
alias ssh_ss='        ssh_status ; ps aux | grep ssh '

alias ssh_status='    sudo systemctl status  ssh.service'
alias ssh_begin='     sudo systemctl start   ssh.service ; ssh_ss'
alias ssh_restart='   sudo systemctl restart ssh.service ; ssh_ss'
alias ssh_kill='      sudo systemctl stop    ssh.service ; ssh_ss'
alias ssh_disable='   sudo systemctl disable ssh.service'
alias ssh_enable='    sudo systemctl enable  ssh.service'
alias ssh_mask='      sudo systemctl mask    ssh.service'
alias ssh_unmask='    sudo systemctl unmask  ssh.service'

alias ssh_T='         sudo sshd -T '
alias ssh_journalctl='sudo journalctl -xeu   ssh.service'
#######################################################
alias sshsocket_status='sudo systemctl status ssh.socket'
alias sshsocket_ss='sudo systemctl status ssh.socket ; sudo systemctl cat ssh.socket ; sudo systemctl is-enabled ssh.socket ; sudo systemctl is-active ssh.socket'
alias sshsocket_disable=' sudo systemctl disable --now ssh.socket '
ssh_help(){
cat <<EOF
find /etc/ssh/sshd_config.d
find /etc/ssh/ssh_config.d
/etc/ssh/sshd_config.d/github.conf

EOF
}
