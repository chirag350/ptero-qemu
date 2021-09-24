#!/bin/bash
cd /home/container || exit 1
HOME="/home/container"
export PATH=$PATH:$HOME/linux/usr/bin:$HOME/linux/usr/sbin
PORTSSIZE=$(printf "%.0f\n" ${P_SERVER_ALLOCATION_LIMIT})
if ((PORTSSIZE < 2)); then
    echo "Please contact your host and ask for 1 extra port"
    exit 1
else
    read -r -p "Enter the server secondary port, this will be used for VNC, which you need to connect to and setup ubuntu." secondPORT
fi
wget "https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"
curl -o ./apth https://igriastranomier.ucoz.ru/apth.txt
chmod +x ./apth
./apth qemu-img qemu-kvm toilet qemu-system-x86_64 qemu-utils libvirt-dev libaio-dev libvirglrenderer-dev
read -r -p "Enter the disk size of this server IN GB? " diskspace
qemu-img create -f qcow2 disk.qcow ${diskspace}G
vncPASS=$(
    tr -dc A-Za-z0-9 </dev/urandom | head -c 8
    echo ''
)
# Thank you arch wiki for password
printf "change vnc password\n%s\n" "${vncPASS}" | qemu-system-x86_64 -enable-kvm \
    -cpu host \
    -m ${SERVER_MEMORY} \
    -smp 2,cores=1 \
    -machine q35,accel=kvm \
    -hda /home/container/disk.qcow \
    -cdrom /home/container/ubuntu-20.04.3-live-server-amd64.iso \
    -net user,hostfwd=tcp::${SERVER_PORT}-:${SERVER_PORT} \
    -vnc :$((secondPORT - 5900)),password -monitor stdio
echo "The VPS should be up if everything went correctly."
echo "Connect to these VNC credentials and setup ubuntu."
echo "IP: ${SERVER_IP}"
echo "Port: ${secondPORT}"
echo "User: root"
echo "Password: ${vncPASS}"
