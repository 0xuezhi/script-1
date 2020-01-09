#!/bin/bash
# Usage:
#   curl https://raw.githubusercontent.com/mixool/script/debian-9/gost.sh | bash

METHOD="-L=mwss://:443 -L=http2://:444"

VER="$(wget -qO- https://github.com/ginuerzh/gost/tags | grep -oE "/tag/v.*" | sed -n '1p' | sed 's/\".*//;s/^.*v//')"
VER=${VER:=2.8.2}
URL="httttps://github.com/ginuerzh/gost/releases/download/v${VER}/gost-linux-amd64-${VER}.gz"

echo "1. Downloading gost-linux-amd64-${VER}.gz to /root/gost from $URL" && echo
[[ -f "/root/gost" ]] && rm -rf /root/gost
wget -O - $URL | gzip -d > /root/gost && chmod +x /root/gost || (echo Woooopss,err!!! && exit 1)

echo "2. Generate /etc/systemd/system/gost.service"
cat <<EOF > /etc/systemd/system/gost.service
[Unit]
Description=gost
[Service]
ExecStart=/root/gost $METHOD
Restart=always
User=root
[Install]
WantedBy=multi-user.target
EOF

systemctl enable gost.service && systemctl daemon-reload && systemctl restart gost.service && systemctl status gost -l
