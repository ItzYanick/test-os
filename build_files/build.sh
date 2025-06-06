#!/bin/bash

set -ouex pipefail

ARCH="$(rpm -E '%_arch')"
KERNEL="$(rpm -q "kernel" --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"
RELEASE="$(rpm -E '%fedora')"

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux 

# dnf5 install -y /ctx/fedora-42-displaylink-1.14.9-2.github_evdi.x86_64.rpm
export CFLAGS="-fno-pie -no-pie"
dnf5 install -y /ctx/kmod-evdi-1.14.9-1.fc42.x86_64.rpm /ctx/akmod-evdi-1.14.9-1.fc42.x86_64.rpm /ctx/displaylink-6.1.0-2.fc42.x86_64.rpm /ctx/libevdi-1.14.9-1.fc42.x86_64.rpm
akmods --force --kernels "${KERNEL}" --kmod evdi
unset CFLAGS
# ls -R /tmp/akmods-extra-rpms
# dnf5 install -y /tmp/akmods-extra-rpms/kmods/*evdi*.rpm
# dnf5 -y remove --no-autoremove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra

# dnf5 -y install \
#     /tmp/kernel-rpms/kernel-[0-9]*.rpm \
#     /tmp/kernel-rpms/kernel-core-*.rpm \
#     /tmp/kernel-rpms/kernel-modules-*.rpm \
#     /tmp/kernel-rpms/kernel-devel-*.rpm

# dnf5 versionlock add kernel kernel-devel kernel-devel-matched kernel-core kernel-modules kernel-modules-core kernel-modules-extra kernel-uki-virt

# dnf5 install -y dkms
# SYSTEMINITDAEMON="systemd" /ctx/displaylink-driver-6.1.1-17.run

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
