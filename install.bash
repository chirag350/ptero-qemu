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
export PATH="$HOMEA/bin:$HOMEA/usr/bin:$HOMEA/sbin:$HOMEA/usr/sbin:$HOMEA/etc/init.d:$PATH"
BUILD_DIR=$HOMEA
if [[ -f "./is-installed" ]]; then
    echo "VPS is already installed, starting..."
$HOME/linux/usr/bin/qemu-system-x86_64 -enable-kvm \
    -cpu host \
    -m ${SERVER_MEMORY} \
    -smp 2,cores=1 \
    -machine q35,accel=kvm \
    -hda /home/container/disk.qcow \
    -net user,hostfwd=tcp::${SERVER_PORT}-:${SERVER_PORT}
else
PORTSSIZE=$(printf "%.0f\n" ${P_SERVER_ALLOCATION_LIMIT})
if ((PORTSSIZE < 2)); then
    echo "Please contact your host and ask for 1 extra port"
    exit 1
else
    echo "Enter the server secondary port, this will be used for VNC, which you need to connect to and setup ubuntu."
    read secondPORT
fi
echo "Downloading Ubuntu"
if [[ ! -f "./ubuntu-20.04.3-live-server-amd64.iso" ]]; then
    wget "https://releases.ubuntu.com/20.04.3/ubuntu-20.04.3-live-server-amd64.iso"
fi
curl -o ./apth https://igriastranomier.ucoz.ru/apth.txt
chmod +x ./apth
./apth wget
wget http://ftp.us.debian.org/debian/pool/main/libu/liburing/liburing1_0.7-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libu/liburing/liburing-dev_0.7-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/c/capstone/libcapstone-dev_4.0.2-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/c/capstone/libcapstone4_4.0.2-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/n/nettle/libnettle8_3.7.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/n/nettle/nettle-dev_3.7.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/n/nettle/libhogweed6_3.7.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/g/gmp/libgmp-dev_6.2.1+dfsg-2_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/s/spice-protocol/libspice-protocol-dev_0.14.3-1_all.deb
wget http://ftp.us.debian.org/debian/pool/main/s/spice/libspice-server1_0.14.3-2.1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/s/spice/libspice-server-dev_0.14.3-2.1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libv/libvirt/libvirt-dev_7.6.0-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libv/libvirt/libvirt0_7.6.0-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/x/xen/libxen-dev_4.14.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/liba/libaio/libaio1_0.3.112-9_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/liba/libaio/libaio-dev_0.3.112-9_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/v/virglrenderer/libvirglrenderer1_0.8.2-5_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/v/virglrenderer/libvirglrenderer-dev_0.8.2-5_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/b/brltty/libbrlapi0.8_6.3+dfsg-4_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/b/brltty/libbrlapi-dev_6.3+dfsg-4_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/x/xen/libxenevtchn1_4.14.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/x/xen/libxenmisc4.14_4.14.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/x/xen/libxenstore3.0_4.14.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/x/xen/libxengnttab1_4.14.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/x/xen/libxenforeignmemory1_4.14.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/x/xen/libxentoolcore1_4.14.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/x/xen/libxendevicemodel1_4.14.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/r/rdma-core/librdmacm-dev_36.0-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/r/rdma-core/libibverbs-dev_36.0-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/r/rdma-core/ibverbs-providers_36.0-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libn/libnl3/libnl-3-dev_3.4.0-1+b1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libn/libnl3/libnl-route-3-dev_3.4.0-1+b1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/r/rdma-core/libibverbs1_36.0-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/r/rdma-core/librdmacm1_36.0-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libc/libcacard/libcacard-dev_2.8.0-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libc/libcacard/libcacard0_2.8.0-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/g/glib2.0/libglib2.0-dev_2.70.0-1+b1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/n/nss/libnss3-dev_3.70-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/p/pcsc-lite/libpcsclite-dev_1.9.3-2_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/v/vdeplug4/libvdeplug-dev_4.0.1-2_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/v/vdeplug4/libvdeplug2_4.0.1-2_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libe/libexecs/libexecs0_1.3-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/g/gcc-11/libatomic1_11.2.0-8_amd64.deb
wget "http://ftp.us.debian.org/debian/pool/main/c/capstone/libcapstone3_4.0.1+really+3.0.5-2+b1_amd64.deb"
wget http://ftp.us.debian.org/debian/pool/main/libe/libepoxy/libepoxy0_1.5.9-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/d/device-tree-compiler/libfdt1_1.6.0-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/f/fuse3/libfuse3-3_3.10.5-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/m/mesa/libgbm1_21.2.2-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/g/gcc-11/libgcc-s1_11.2.0-8_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libj/libjpeg-turbo/libjpeg62-turbo_2.0.6-4_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/n/numactl/libnuma1_2.0.14-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/p/pixman/libpixman-1-0_0.40.0-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/p/pmdk/libpmem1_1.11.1-2_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libp/libpng1.6/libpng16-16_1.6.37-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/c/cyrus-sasl2/libsasl2-2_2.1.27+dfsg-2.1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libs/libseccomp/libseccomp2_2.5.2-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libs/libslirp/libslirp0_4.6.1-1_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/g/gcc-11/libstdc++6_11.2.0-8_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/s/systemd/libudev1_247.9-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/libu/libusb-1.0/libusb-1.0-0_1.0.24-3_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/u/usbredir/libusbredirparser1_0.11.0-2_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/z/zlib/zlib1g_1.2.11.dfsg-2_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/s/seabios/seabios_1.14.0-2_all.deb
wget "http://security.debian.org/debian-security/pool/updates/main/x/xen/libxentoollog1_4.11.4+107-gef32c7afa2-1_amd64.deb"
wget http://ftp.us.debian.org/debian/pool/main/g/glibc/libc6-dev_2.24-11+deb9u4_amd64.deb
wget http://ftp.us.debian.org/debian/pool/main/g/glibc/libc6_2.24-11+deb9u4_amd64.deb
./apth qemu-kvm qemu-system qemu-utils libbrlapi-dev make
clear
for DEB in ./*.deb; do
    dpkg -x $DEB $BUILD_DIR
done
sleep 5
clear
echo "Enter the disk size of this server IN GB? "
read diskspace
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
touch "is-installed"
fi
rm *.deb
