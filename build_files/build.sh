#!/bin/bash
set -ouex pipefail

###################################################################################

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/43/x86_64/repoview/index.html&protocol=https&redirect=1

# this installs a package from fedora repos
# dnf5 install -y tmux 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

# systemctl enable podman.socket
###################################################################################


ARCH=$(uname -m)
echo "ARCHITECTURE = $ARCH"

RELEASE="$(rpm -E %fedora)"
echo "RELEASE = $RELEASE"

### DIRECT REPO INSTALLS

#  - vscode repo
curl -o /etc/yum.repos.d/vscode.repo "https://packages.microsoft.com/yumrepos/vscode/config.repo"

# - virtio-win repo
curl -o /etc/yum.repos.d/virtio-win.repo "https://fedorapeople.org/groups/virt/virtio-win/virtio-win.repo"

# ENABLE THE COPR REPOS:
dnf5 -y copr enable refi64/webapp-manager

### Install packages

# Development Tools
dnf5 -y install \
    code \
    code-insiders

# Media & Recording
dnf5 -y install \
    obs-studio

# Web Browsers & Apps
dnf5 -y install \
    firefox \
    thunderbird \
    webapp-manager \
    chromium

# Firefox PWA (not available in repos, so we install it directly from the RPM)
curl -Lo /tmp/firefoxpwa.rpm https://github.com/filips123/PWAsForFirefox/releases/download/v2.18.0/firefoxpwa-2.18.0-1.x86_64.rpm
dnf5 -y install /tmp/firefoxpwa.rpm
# rm -f /tmp/firefoxpwa.rpm

# Terminal Utilities
dnf5 -y install \
    screen \
    stow

# Fonts
dnf5 -y install \
    jetbrains-mono-fonts \
    mscore-fonts

# VM/Virtualization Packages
dnf5 -y install \
    spice-vdagent \
    qemu-guest-agent \
    virtio-win \
    virtiofsd


# X-Plane 12 related packages
dnf5 -y install \
    freeglut \
    openal-soft \
    libcurl \
    libcurl-devel \
    switcheroo-control \
    gtk3 \
    libglvnd-glx

# Build and install elgato4k-linux
dnf5 -y install \
    libusb1-devel 

(
    cd /tmp
    git clone https://github.com/13bm/elgato4k-linux.git
    cd elgato4k-linux
    cargo build --release
    cp target/release/elgato4k-linux /usr/local/bin/
    cd /tmp
    rm -rf elgato4k-linux
)




    
