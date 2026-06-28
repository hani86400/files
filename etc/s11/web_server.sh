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

#1521 ICAgIFBZX1BPUlQ9IjE1MjEiCiAgICBQWV9CSU5EPSIwLjAuMC4wIgogICAgUFlfRElSPSIvdG1wL3d3dyR7UFlfUE9SVH0iCgogICAgQzE9JChwcmludGYgJyMlMDZ4JyAkKChSQU5ET00gKiAxNjc3NzIxNSAvIDMyNzY3KSkpCiAgICBDMj0kKHByaW50ZiAnIyUwNngnICQoKDB4RkZGRkZGIC0gMHgke0MxI1wjfSkpKQogICAgbWtkaXIgLXB2ICIke1BZX0RJUn0iL3tjZ2ktYmluLGh0bWx9CiAgICBjZCAiJHtQWV9ESVJ9L2h0bWwiIAogICAgY2F0ID4gIiR7UFlfRElSfS9odG1sL2luZGV4Lmh0bWwiIDw8RU9GCiAgICA8IURPQ1RZUEUgaHRtbD48aHRtbCBsYW5nPSJlbiI+CiAgICA8aGVhZD48dGl0bGU+UFlfU0VSVkVSXyR7UFlfUE9SVH08L3RpdGxlPjwvaGVhZD4KICAgIDxib2R5IHN0eWxlPSJiYWNrZ3JvdW5kLWNvbG9yOiAke0MxfTsgY29sb3I6ICR7QzJ9OyI+PGgxPlB5dGhvbiBzZXJ2ZXIgb24gcG9ydCAke1BZX1BPUlR9IGJpbmQgJHtQWV9CSU5EfSB3d3dfZGlyICR7UFlfRElSfTwvaDE+PC9ib2R5PgogICAgPC9odG1sPgpFT0YKICAgIGNobW9kIC1SIDc1NSAiJHtQWV9ESVJ9IgogICAgIyBLaWxsIGV4aXN0aW5nIHB5dGhvbiBodHRwLnNlcnZlciBvbiBzYW1lIHBvcnQKICAgIFBJRFM9JChwcyBhdXggfCBncmVwICdbaF10dHAuc2VydmVyJyB8IGdyZXAgIiR7UFlfUE9SVH0iIHwgYXdrICd7cHJpbnQgJDJ9JykKICAgIGlmIFsgLW4gIiRQSURTIiBdOyB0aGVuCiAgICAgICAga2lsbCAkUElEUwogICAgZmkKICAgIHJtIC1yZiAiJHtQWV9ESVJ9L2NnaS1iaW4vX19weWNhY2hlX18iCnNldCAteCAgICAKbm9odXAgcHl0aG9uMyAtbSBodHRwLnNlcnZlciAiJHtQWV9QT1JUfSIgLS1iaW5kICIke1BZX0JJTkR9IiAtLWRpcmVjdG9yeSAiJHtQWV9ESVJ9IiAgLS1jZ2kgPiAiJHtQWV9ESVJ9L3NlcnZlci5sb2ciIDI+JjEgJgpzZXQgK3gK