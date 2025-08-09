#!/usr/bin/bash

if [ ! -e "/var/lib/vz/snippets" ]; then
    mkdir -p /var/lib/vz/snippets
fi

if [ !-e "/etc/systemd/system/fifo.service" ]; then

fi

INSTALLPATH=$(pwd)

cat > /var/lib/vz/snippets/pvevm-hooks-uhd.sh <<EOF
#!/usr/bin/bash
$INSTALLPATH/vm-hook.sh \$*
EOF

chmod +x /var/lib/vz/snippets/pvevm-hooks-uhd.sh

if [ "$1" ]; then
    qm set $1 --hookscript local:snippets/pvevm-hooks-uhd.sh
fi