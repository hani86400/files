


export BACKUP8_SCRIPT='/opt/hostinger/backup8.sh' 
export BACKUP8_LOG_FILE='/opt/hostinger/backup8.log'
export BACKUP8_HOME='/opt/hostinger'

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
 RSYNC_OPTS="-vah"

alias backup8_go='      /opt/hostinger/backup8.sh'
alias backup8_run='      /opt/hostinger/backup8.sh'
alias backup8_edit='nano /opt/hostinger/backup8.sh'
alias backup8_nano='nano /opt/hostinger/backup8.sh'
alias backup8_timer='systemctl list-timers --all | grep backup8'


alias backup8_status='    sudo systemctl status  backup8.service'
alias backup8_begin='     sudo systemctl start   backup8.service ; backup8_status'
alias backup8_restart='   sudo systemctl restart backup8.service ; backup8_status'
alias backup8_kill='      sudo systemctl stop    backup8.service ; backup8_status'
alias backup8_disable='   sudo systemctl disable backup8.service'
alias backup8_enable='    sudo systemctl enable  backup8.service'
alias backup8_mask='      sudo systemctl mask    backup8.service'
alias backup8_unmask='    sudo systemctl unmask  backup8.service'
alias backup8_journalctl='sudo journalctl -xeu   backup8.service'


alias backup8_t_status='    sudo systemctl status  backup8.timer'
alias backup8_t_begin='     sudo systemctl start   backup8.timer ; backup8_t_status'
alias backup8_t_restart='   sudo systemctl restart backup8.timer ; backup8_t_status'
alias backup8_t_kill='      sudo systemctl stop    backup8.timer ; backup8_t_status'
alias backup8_t_disable='   sudo systemctl disable backup8.timer'
alias backup8_t_enable='    sudo systemctl enable  backup8.timer'
alias backup8_t_mask='      sudo systemctl mask    backup8.timer'
alias backup8_t_unmask='    sudo systemctl unmask  backup8.timer'
alias backup8_t_journalctl='sudo journalctl -xeu   backup8.timer'

fs_du () 
{ 
    if [ -z "$1" ]; then
        T_DIR='.';
    else
        T_DIR=$(readlink -f "$1");
    fi;
    shift;
    if [ -z "$1" ]; then
        T_MAX_DEPTH='1';
    else
        T_MAX_DEPTH="$1";
    fi;
    du "${T_DIR}" --max-depth=${T_MAX_DEPTH} | sort -h -k 1;
    ls --color=auto -ld ${T_DIR}
}

