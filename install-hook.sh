#!/usr/bin/bash
INSTALLPATH=$(realpath $(dirname $0))

if [ ! -e "$INSTALLPATH/vz/snippets" ]; then
    mkdir -p $INSTALLPATH/vz/snippets
fi

if [ ! -e "/etc/systemd/system/fifo.service" ]; then

cat > /etc/systemd/system/fifo.service <<EOF
[Unit]
Description=FIFO QUEUE
After=network-online.target

[Service]
ExecStart=/usr/bin/bash $INSTALLPATH/fifo/queue.sh
WorkingDirectory=$INSTALLPATH/fifo
User=root
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

chmod +x $INSTALLPATH/fifo/queue.sh
systemctl enable fifo.service
systemctl start fifo.service &

fi

cat > $INSTALLPATH/vz/snippets/pvevm-hooks-uhd.sh <<EOF
#!/usr/bin/bash
$INSTALLPATH/pvevm-hooks/vm-hook.sh \$*
EOF

chmod +x $INSTALLPATH/vz/snippets/pvevm-hooks-uhd.sh
chmod +x $INSTALLPATH/pvevm-hooks/*.sh

if [ "$1" ]; then
    if [ ! "$(pvesm status|sed '1d'|awk '{print $1}'|grep -x pvevm-hooks-uhd)" ]; then
        pvesm add dir pvevm-hooks-uhd --content snippets --path $INSTALLPATH/vz
    fi
    qm set $1 --hookscript pvevm-hooks-uhd:snippets/pvevm-hooks-uhd.sh
    else
    echo "useage: ./install-hook.sh <vmid>"
fi