alias find_caddy='sudo find /etc/caddy /var/lib/caddy /var/log/caddy ; ls -l /usr/bin/caddy ; ls -l /etc/systemd/system | grep -i caddy'
#-------------------------------------------------------------------
alias caddy_n8n_B=' sudo systemctl  start   caddy_n8n.service ; caddy_n8n_SS'
alias caddy_n8n_K=' sudo systemctl  stop    caddy_n8n.service ; caddy_n8n_SS'
alias caddy_n8n_R=' sudo systemctl  restart caddy_n8n.service ; caddy_n8n_SS'
alias caddy_n8n_M=' sudo systemctl  mask    caddy_n8n.service'
alias caddy_n8n_D=' sudo systemctl  disable caddy_n8n.service'
alias caddy_n8n_E=' sudo systemctl  enable  caddy_n8n.service'
alias caddy_n8n_J=' sudo journalctl -xeu    caddy_n8n.service --no-pager  -n 40'
alias caddy_n8n_S=' sudo systemctl  status  caddy_n8n.service'
alias caddy_n8n_SS=' caddy_app_S ; ps aux | grep caddy ;  sudo systemctl show caddy_n8n.service --property=Environment '
alias caddy_n8n_F=' sudo caddy fmt --overwrite   /etc/caddy/Caddyfile.n8n'
alias caddy_n8n_V=' sudo caddy validate --config /etc/caddy/Caddyfile.n8n'

#-------------------------------------------------------------------
alias caddy_app_B=' sudo systemctl  start   caddy_app.service ; caddy_app_SS'
alias caddy_app_K=' sudo systemctl  stop    caddy_app.service ; caddy_app_SS'
alias caddy_app_R=' sudo systemctl  restart caddy_app.service ; caddy_app_SS'
alias caddy_app_M=' sudo systemctl  mask    caddy_app.service'
alias caddy_app_D=' sudo systemctl  disable caddy_app.service'
alias caddy_app_E=' sudo systemctl  enable  caddy_app.service'
alias caddy_app_J=' sudo journalctl -xeu    caddy_app.service --no-pager  -n 40'
alias caddy_app_S=' sudo systemctl  status  caddy_app.service'
alias caddy_app_SS=' caddy_app_S ; ps aux | grep caddy ;  sudo systemctl show caddy_app.service --property=Environment '
alias caddy_app_F=' sudo caddy fmt --overwrite   /etc/caddy/Caddyfile.app'
alias caddy_app_V=' sudo caddy validate --config /etc/caddy/Caddyfile.app'
alias caddy_app_A='echo -e "\nsudo htpasswd -c /tmp/.htpasswd davuser xyz \ncaddy hash-password --plaintext yourpassword \nsudo chown root:caddy /etc/caddy/auth.caddy \nsudo chmod 640 /etc/caddy/auth.caddy"'
###############################################################
alias nginx_B=' sudo systemctl  start   nginx.service ; nginx_SS'
alias nginx_K=' sudo systemctl  stop    nginx.service ; nginx_SS'
alias nginx_R=' sudo systemctl  restart nginx.service ; nginx_SS'

alias nginx_M=' sudo systemctl  mask    nginx.service'
alias nginx_D=' sudo systemctl  disable nginx.service'
alias nginx_E=' sudo systemctl  enable  nginx.service'

alias nginx_J=' sudo journalctl -xeu    nginx.service --no-pager  -n 40'

alias nginx_S=' sudo systemctl  status  nginx.service'
alias nginx_SS=' nginx_S ; ps aux | grep nginx ; sudo nginx -t '

alias find_nginx='sudo ls -lR /etc/nginx /var/log/nginx/ ; sudo nginx -t '
###############################################################
alias urllogger_B=' sudo systemctl  start   urllogger.service ; urllogger_SS'
alias urllogger_K=' sudo systemctl  stop    urllogger.service ; urllogger_SS'
alias urllogger_R=' sudo systemctl  restart urllogger.service ; urllogger_SS'
alias urllogger_M=' sudo systemctl  mask    urllogger.service'
alias urllogger_D=' sudo systemctl  disable urllogger.service'
alias urllogger_E=' sudo systemctl  enable  urllogger.service'
alias urllogger_J=' sudo journalctl -xeu    urllogger.service --no-pager  -n 40'
alias urllogger_S=' sudo systemctl  status  urllogger.service'

alias urllogger_SS=' urllogger_S ; ps aux | grep node'
alias find_node='sudo find /srv/app ; ls -l /usr/bin/node ; ls -l /etc/systemd/system | grep -i urllogger'
###############################################################


