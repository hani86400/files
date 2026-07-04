# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [ NW General ] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
alias nw_ss='ss -tulpn '
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [ Nginx ] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
aliss cdnginx=' cd /etc/nginx        ; ls -latr' 
aliss cdnginxc='cd /etc/nginx/conf.d ; ls -latr' 
aliss cdnginxl='cd /var/log/nginx    ; ls -latr'


alias nginx_ss='        nginx_status ; ps aux | grep nginx '

alias nginx_status='    sudo systemctl status  nginx.service'
alias nginx_begin='     sudo systemctl start   nginx.service ; nginx_ss'
alias nginx_restart='   sudo systemctl restart nginx.service ; nginx_ss'
alias nginx_kill='      sudo systemctl stop    nginx.service ; nginx_ss'
alias nginx_disable='   sudo systemctl disable nginx.service'
alias nginx_enable='    sudo systemctl enable  nginx.service'
alias nginx_mask='      sudo systemctl mask    nginx.service'
alias nginx_unmask='    sudo systemctl unmask  nginx.service'

alias nginx_t='         sudo nginx -T ; sudo nginx -t '
alias nginx_T='         sudo nginx -T ; sudo nginx -t '
alias nginx_journalctl='sudo journalctl -xeu   nginx.service'
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
# : [ S S H ] 
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
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
nano /home/hani/.ssh/authorized_keys 
grep -nR "PasswordAuthentication" /etc/ssh
sudo /usr/sbin/sshd -f /etc/ssh/sshd_config -T | grep passwordauthentication

EOF
}
# :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
