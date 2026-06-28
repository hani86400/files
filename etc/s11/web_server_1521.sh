    PY_PORT="1521"
    PY_BIND="0.0.0.0"
    PY_DIR="/tmp/www${PY_PORT}"

    C1=$(printf '#%06x' $((RANDOM * 16777215 / 32767)))
    C2=$(printf '#%06x' $((0xFFFFFF - 0x${C1#\#})))
    mkdir -pv "${PY_DIR}"/{cgi-bin,html}
    cd "${PY_DIR}/html" 
    cat > "${PY_DIR}/html/index.html" <<EOF
    <!DOCTYPE html><html lang="en">
    <head><title>PY_SERVER_${PY_PORT}</title></head>
    <body style="background-color: ${C1}; color: ${C2};"><h1>Python server on port ${PY_PORT} bind ${PY_BIND} www_dir ${PY_DIR}</h1></body>
    </html>
EOF
    chmod -R 755 "${PY_DIR}"
    # Kill existing python http.server on same port
    PIDS=$(ps aux | grep '[h]ttp.server' | grep "${PY_PORT}" | awk '{print $2}')
    if [ -n "$PIDS" ]; then
        kill $PIDS
    fi
    rm -rf "${PY_DIR}/cgi-bin/__pycache__"
set -x    
nohup python3 -m http.server "${PY_PORT}" --bind "${PY_BIND}" --directory "${PY_DIR}"  --cgi > "${PY_DIR}/server.log" 2>&1 &
set +x
