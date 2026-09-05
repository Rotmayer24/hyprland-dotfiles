#!/bin/bash
# Usage: echo "password" | ./checkpassword.sh [username]
# Exits 0 if password is correct, 1 if wrong

USER="${1:-$USER}"
PASS="$(cat)"

python3 -c "
import subprocess, os, pty, time, sys

password = sys.argv[1]
user = sys.argv[2]

master, slave = pty.openpty()
p = subprocess.Popen(['su', '-c', 'exit 0', user],
    stdin=slave, stdout=slave, stderr=slave)
os.close(slave)

time.sleep(0.3)
try:
    os.read(master, 1024)
except:
    pass

os.write(master, (password + '\n').encode())
time.sleep(0.5)
try:
    os.read(master, 1024)
except:
    pass

p.wait()
os.close(master)
sys.exit(p.returncode)
" "$PASS" "$USER"
