#!/bin/bash
cd /home/container || exit 1
HOME="/home/container"
HOMEA="$HOME/linux/.apt"
STAR1="$HOMEA/lib:$HOMEA/usr/lib:$HOMEA/var/lib:$HOMEA/usr/lib/x86_64-linux-gnu:$HOMEA/lib/x86_64-linux-gnu:$HOMEA/lib:$HOMEA/usr/lib/sudo"
STAR2="$HOMEA/usr/include/x86_64-linux-gnu:$HOMEA/usr/include/x86_64-linux-gnu/bits:$HOMEA/usr/include/x86_64-linux-gnu/gnu"
STAR3="$HOMEA/usr/share/lintian/overrides/:$HOMEA/usr/src/glibc/debian/:$HOMEA/usr/src/glibc/debian/debhelper.in:$HOMEA/usr/lib/mono"
STAR4="$HOMEA/usr/src/glibc/debian/control.in:$HOMEA/usr/lib/x86_64-linux-gnu/libcanberra-0.30:$HOMEA/usr/lib/x86_64-linux-gnu/libgtk2.0-0"
STAR5="$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/modules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/immodules:$HOMEA/usr/lib/x86_64-linux-gnu/gtk-2.0/2.10.0/printbackends"
STAR6="$HOMEA/usr/lib/x86_64-linux-gnu/samba/:$HOMEA/usr/lib/x86_64-linux-gnu/pulseaudio:$HOMEA/usr/lib/x86_64-linux-gnu/blas:$HOMEA/usr/lib/x86_64-linux-gnu/blis-serial"
STAR7="$HOMEA/usr/lib/x86_64-linux-gnu/blis-openmp:$HOMEA/usr/lib/x86_64-linux-gnu/atlas:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-miners-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/tracker-2.0:$HOMEA/usr/lib/x86_64-linux-gnu/lapack:$HOMEA/usr/lib/x86_64-linux-gnu/gedit"
STARALL="$STAR1:$STAR2:$STAR3:$STAR4:$STAR5:$STAR6:$STAR7"
export LD_LIBRARY_PATH=$STARALL
PATH="$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
PORTSSIZE=$(printf "%.0f\n" ${P_SERVER_ALLOCATION_LIMIT})
if ((PORTSSIZE < 2)); then
    echo "Please contact your host and ask for 1 extra port"
    exit 1
else
    echo "Enter the server secondary port, this will be used for VNC, which you need to connect to and setup ubuntu."
    read -r secondPORT
fi
if [[ ! -f "./ubuntu-20.04.3-live-server-amd64.iso" ]]; then
    wget "https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"
fi
curl -o ./apth https://igriastranomier.ucoz.ru/apth.txt
chmod +x ./apth
./apth libcapstone-dev qemu-kvm qemu-system qemu-utils libvirt-dev libaio-dev libvirglrenderer-dev libbrlapi-dev git make build-essentials
git clone https://github.com/axboe/liburing
cd liburing
./configure --prefix=/home/container/linux/usr/
make
make install
cd ..
rm -rf ./liburing/
echo "Enter the disk size of this server IN GB? "
read -r diskspace
$HOME/linux/usr/bin/qemu-img create -f qcow2 disk.qcow ${diskspace}G
vncPASS=$(
    tr -dc A-Za-z0-9 </dev/urandom | head -c 8
    echo ''
)
# Thank you arch wiki for password
printf "change vnc password\n%s\n" "${vncPASS}" | $HOME/linux/usr/bin/qemu-system-x86_64 -enable-kvm \
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
