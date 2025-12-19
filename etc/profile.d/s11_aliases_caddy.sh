alias caddy_B=' sudo systemctl  start   caddy_n8n.service ; caddy_SS'
alias caddy_K=' sudo systemctl  stop    caddy_n8n.service ; caddy_SS'
alias caddy_R=' sudo systemctl  restart caddy_n8n.service ; caddy_SS'

alias caddy_M=' sudo systemctl  mask    caddy_n8n.service'
alias caddy_D=' sudo systemctl  disable caddy_n8n.service'
alias caddy_E=' sudo systemctl  enable  caddy_n8n.service'

alias caddy_J=' sudo journalctl -xeu    caddy_n8n.service -no-pager  -n 40'

alias caddy_S=' sudo systemctl  status  caddy_n8n.service'
alias caddy_SS=' caddy_S ; ps aux | grep caddy'

alias find_caddy='find /etc/caddy /var/lib/caddy /var/log/caddy ; ls -l /usr/bin/caddy'
