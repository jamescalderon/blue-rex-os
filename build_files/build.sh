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

# Variables for general use
    ARCH=$(uname -m)
    echo "ARCHITECTURE = $ARCH"

    RELEASE="$(rpm -E %fedora)"
    echo "RELEASE = $RELEASE"

### DIRECT REPO INSTALLS

# vscode repo
    curl -o /etc/yum.repos.d/vscode.repo "https://packages.microsoft.com/yumrepos/vscode/config.repo"

# virtio-win repo
    curl -o /etc/yum.repos.d/virtio-win.repo "https://fedorapeople.org/groups/virt/virtio-win/virtio-win.repo"

# ENABLE THE COPR REPOS:
    dnf5 -y copr enable refi64/webapp-manager

### Install Packages

# Misc Utilities
    dnf5 -y install \
        screen \
        stow \
        gparted

# Development Tools
    dnf5 -y install \
        code \
        code-insiders

# Media & Recording
    dnf5 -y install \
        ffmpeg-free \
        libva-utils \
        obs-studio \
        obs-studio-plugin-pwvideo

# Web Browsers & Apps
    dnf5 -y install \
        firefox \
        thunderbird \
        webapp-manager \
        chromium

# Firefox PWA (not available in repos, so we install it directly from the RPM)
    curl -Lo /tmp/firefoxpwa.rpm https://github.com/filips123/PWAsForFirefox/releases/download/v2.18.0/firefoxpwa-2.18.0-1.x86_64.rpm
    dnf5 -y install /tmp/firefoxpwa.rpm

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

# Install elgato4k-linux from release tarball -  Using pre-built binary
    dnf5 -y install libusb1

    # Get the latest release URL from GitHub API
    ELGATO_LATEST_URL=$(curl -s https://api.github.com/repos/13bm/elgato4k-linux/releases/latest | grep "browser_download_url.*x86_64-linux.tar.gz" | cut -d '"' -f 4)
    
    curl -Lo /tmp/elgato4k-linux.tar.gz "$ELGATO_LATEST_URL"

    # curl -Lo /tmp/elgato4k-linux.tar.gz https://github.com/13bm/elgato4k-linux/releases/download/v0.2.2/elgato4k-linux-v0.2.2-x86_64-linux.tar.gz
    tar -xzf /tmp/elgato4k-linux.tar.gz -C /tmp

    # Install to /usr/bin (not /usr/local/bin) for atomic/immutable systems - using both file names due do doc changes
    cp /tmp/elgato4k-linux /usr/bin/elgato4k-linux
    chmod +x /usr/bin/elgato4k-linux

    cp /tmp/elgato4k-linux /usr/bin/elgato4k
    chmod +x /usr/bin/elgato4k

# Final Cleanup
    rm -f /tmp/firefoxpwa.rpm
    rm -f /tmp/elgato4k-linux.tar.gz /tmp/elgato4k-linux /tmp/LOW_CONFIDENCE_COMMANDS.md /tmp/README.md
    
    # Disable COPRs so they don't end up enabled on the final image:
    dnf5 -y copr disable refi64/webapp-manager





    
