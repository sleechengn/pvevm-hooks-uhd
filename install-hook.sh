#!/usr/bin/bash
INSTALLPATH=$(pwd)

if [ ! -e "/var/lib/vz/snippets" ]; then
    mkdir -p /var/lib/vz/snippets
fi

if [ ! -e "/etc/systemd/system/fifo.service" ]; then

cat > /etc/systemd/system/fifo.service <<EOF
[Unit]
Description=FIFO QUEUE
After=network-online.target

[Service]
ExecStart=$INSTALLPATH/fifo/queue.sh
WorkingDirectory=$INSTALLPATH/fifo
User=root
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

chmod +x $INSTALLPATH/fifo/queue.sh
systemctl enable fifo.service
systemctl start fifo.service

fi

cat > /var/lib/vz/snippets/pvevm-hooks-uhd.sh <<EOF
#!/usr/bin/bash
$INSTALLPATH/pvevm-hooks/vm-hook.sh \$*
EOF

chmod +x /var/lib/vz/snippets/pvevm-hooks-uhd.sh
chmod +x $INSTALLPATH/pvevm-hooks/*.sh

if [ "$1" ]; then
    qm set $1 --hookscript local:snippets/pvevm-hooks-uhd.sh
    else
    echo "useage: ./install-hook.sh <vmid>"
fi