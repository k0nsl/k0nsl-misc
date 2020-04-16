###################################################################
#      Easily build a kernel for Ubuntu-based distributions.      #
#                                                                 #
# NOTE:                                                           #
#  Substitute version (currently set for v5.6) by replacing the   #
#  appropriate version you want to build by going to kernel.org   #
#  and finding the one you want. Very simple.                     #
###################################################################

mkdir ~/linux-kernel-build
cd ~/linux-kernel-build
wget -c https://mirrors.edge.kernel.org/pub/linux/kernel/v5.x/linux-5.6.tar.xz
cd linux-5.6

wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6/0001-base-packaging.patch
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6/0004-debian-changelog.patch
wget -c https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.6/0005-configs-based-on-Ubuntu-5.6.0-6.6.patch

patch -p1 <0001-base-packaging.patch
patch -p1 <0004-debian-changelog.patch
patch -p1 <0005-configs-based-on-Ubuntu-5.6.0-6.6.patch
 
chmod a+x debian/rules

fakeroot debian/rules clean
fakeroot debian/rules do_extras_package=false do_tools=false binary-headers binary-generic


###################################################################
#                              END                                #
# This script will only build the kernel; you have to install it  #
# on your own which is even simpler than building it.             #
###################################################################
