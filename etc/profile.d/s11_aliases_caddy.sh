alias caddy_B=' sudo systemctl  start   caddy_n8n.service ; caddy_SS'
alias caddy_K=' sudo systemctl  stop    caddy_n8n.service ; caddy_SS'
alias caddy_R=' sudo systemctl  restart caddy_n8n.service ; caddy_SS'

alias caddy_M=' sudo systemctl  mask    caddy_n8n.service'
alias caddy_D=' sudo systemctl  disable caddy_n8n.service'
alias caddy_E=' sudo systemctl  enable  caddy_n8n.service'

alias caddy_J=' sudo journalctl -xeu    caddy_n8n.service --no-pager  -n 40'

alias caddy_S=' sudo systemctl  status  caddy_n8n.service'
alias caddy_SS=' caddy_S ; ps aux | grep caddy'

alias find_caddy='sudo find /etc/caddy /var/lib/caddy /var/log/caddy ; ls -l /usr/bin/caddy'
###############################################################
alias nginx_B=' sudo systemctl  start   nginx.service ; nginx_SS'
alias nginx_K=' sudo systemctl  stop    nginx.service ; nginx_SS'
alias nginx_R=' sudo systemctl  restart nginx.service ; nginx_SS'

alias nginx_M=' sudo systemctl  mask    nginx.service'
alias nginx_D=' sudo systemctl  disable nginx.service'
alias nginx_E=' sudo systemctl  enable  nginx.service'

alias nginx_J=' sudo journalctl -xeu    nginx.service --no-pager  -n 40'

alias nginx_S=' sudo systemctl  status  nginx.service'
alias nginx_SS=' nginx_S ; ps aux | grep nginx'

alias find_nginx='sudo ls -lR /etc/nginx /var/log/nginx/ ; sudo nginx -t '
