export S11_DC_DIR='/opt/s11_wd/dc'


alias dc_cp='docker cp '
alias dc_nw='docker network ls'
alias dc_img='docker images'

function dc_ps(){ docker stats --no-stream -a ; echo ' ' ; docker ps -a ; }
function dc_kill_all_container(){ docker stop  $(docker ps -a -q) ; docker rm    $(docker ps -a -q) ; dc_ps ; }
function dc_kill_container(){ 
local T_CONTAINER_NAME=$1
local T_CONTAINER_ID=$( docker ps -a | grep  "${T_CONTAINER_NAME}" | awk '{print $1}' )
docker stop ${T_CONTAINER_ID}
docker rm   ${T_CONTAINER_ID}
}


dc_2_bb_d_h(){ cd "${S11_DC_DIR}" ; docker compose -f dc_bb_d_h.yaml      down ; docker compose -f dc_bb_d_h.yaml     up -d ; }
dc_1_bb_d_h(){ cd "${S11_DC_DIR}" ; docker compose -f dc_bb_d_h.yaml      down ; docker compose -f dc_bb_d_h.yaml     up    ; }
dc_0_bb_d_h(){ cd "${S11_DC_DIR}" ; docker compose -f dc_bb_d_h.yaml      down                                              ; }



dc_2_n8n(){ cd "${S11_DC_DIR}" ; docker compose -f dc_n8n.yaml      down ; docker compose -f dc_n8n.yaml     up -d ; }
dc_1_n8n(){ cd "${S11_DC_DIR}" ; docker compose -f dc_n8n.yaml      down ; docker compose -f dc_n8n.yaml     up    ; }
dc_0_n8n(){ cd "${S11_DC_DIR}" ; docker compose -f dc_n8n.yaml      down                                           ; }



dc_2_m1me(){ cd "${S11_DC_DIR}" ; docker compose -f dc_m1me.yaml    down ; docker compose -f dc_m1me.yaml    up -d ; }
dc_1_m1me(){ cd "${S11_DC_DIR}" ; docker compose -f dc_m1me.yaml    down ; docker compose -f dc_m1me.yaml    up    ; }
dc_0_m1me(){ cd "${S11_DC_DIR}" ; docker compose -f dc_m1me.yaml    down                                           ; }
dc_2_m2(){   cd "${S11_DC_DIR}" ; docker compose -f dc_m2.yaml      down ; docker compose -f dc_m2.yaml      up -d ; }
dc_1_m2(){   cd "${S11_DC_DIR}" ; docker compose -f dc_m2.yaml      down ; docker compose -f dc_m2.yaml      up    ; }
dc_0_m2(){   cd "${S11_DC_DIR}" ; docker compose -f dc_m2.yaml      down                                           ; }
dc_2_me82(){ cd "${S11_DC_DIR}" ; docker compose -f dc_me82.yaml    down ; docker compose -f dc_me82.yaml    up -d ; }
dc_1_me82(){ cd "${S11_DC_DIR}" ; docker compose -f dc_me82.yaml    down ; docker compose -f dc_me82.yaml    up    ; }
dc_0_me82(){ cd "${S11_DC_DIR}" ; docker compose -f dc_me82.yaml    down                                           ; }
dc_2_me83(){ cd "${S11_DC_DIR}" ; docker compose -f dc_meatlas.yaml down ; docker compose -f dc_meatlas.yaml up -d ; }
dc_1_me83(){ cd "${S11_DC_DIR}" ; docker compose -f dc_meatlas.yaml down ; docker compose -f dc_meatlas.yaml up    ; }
dc_0_me83(){ cd "${S11_DC_DIR}" ; docker compose -f dc_meatlas.yaml down                                           ; }

dc_exec_m1_mongosh()     { docker exec -it mongodb1 mongosh "mongodb://admin:password@localhost:27017" ; }
dc_exec_m1_env()         { docker exec -it mongodb1 env ; }
dc_exec_m1_bash()        { docker exec -it mongodb1 /bin/bash ; }
dc_exec_m1_mongoimport() { docker exec -i  mongodb1 mongoimport --db=mycompany --collection=employees  --file=/data/employees.json    --uri="mongodb://admin:password@localhost:27017/mycompany?authSource=admin" ; }
dc_exec_m1_mongoexport() { docker exec -i  mongodb1 mongoexport --db=mycompany --collection=employees  --out=/data/exp_employees.json --uri="mongodb://admin:password@localhost:27017/mycompany?authSource=admin" ; }

dc_exec_m2_mongosh()     { docker exec -it mongodb2 mongosh "mongodb://admin:password@localhost:27017" ; }
dc_exec_m2_env()         { docker exec -it mongodb2 env ; }
dc_exec_m2_bash()        { docker exec -it mongodb2 /bin/bash ; }
dc_exec_m2_mongoimport() { docker exec -i  mongodb2 mongoimport --db=mycompany --collection=employees  --file=/data/employees.json    --uri="mongodb://admin:password@localhost:27017/mycompany?authSource=admin" ; }
dc_exec_m2_mongoexport() { docker exec -i  mongodb2 mongoexport --db=mycompany --collection=employees  --out=/data/exp_employees.json --uri="mongodb://admin:password@localhost:27017/mycompany?authSource=admin" ; }


dc_run_opensusessh() { docker run -p 22156:22 --name opensusessh31 -it opensusessh:15.6 "/usr/sbin/sshd" "-D" ; }


#######################################################################
# f u n c t i o n                                       [2025_03_07 ] #
                 docker_build() {
# $1 : DOCKER_CONTEXT
# $1 : IMAGE_NAME_TAG
# $2 : DOCKER_FILE

#######################################################################
    # usage: docker_build DOCKER_CONTEXT IMAGE_NAME_TAG DOCKER_FILE

    local context image_tag dockerfile

    if [ $# -lt 3 ]; then
        echo "Usage: docker_build DOCKER_CONTEXT IMAGE_NAME_TAG DOCKER_FILE"
        return 1
    fi

    context="$1"
    image_tag="$2"
    dockerfile="$3"

    if ! cd "$context"; then
        echo -e "\e[1;91mError: invalid DOCKER_CONTEXT: $context\e[0m"
        return 1
    fi

    echo -e "Try to build: \e[1;96m${image_tag}\e[0m using \e[1;93m${dockerfile}\e[0m"

    # remove old image if it exists, ignore failure
    docker image rm "$image_tag" 2>/dev/null

    # build new one
    docker build . --no-cache -f "$dockerfile" -t "$image_tag"

    # list what we built to feel productive
    docker image ls | grep --color=auto "$image_tag"

} # f u n c t i o n [END] #############################################

