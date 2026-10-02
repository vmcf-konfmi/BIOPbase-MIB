# Target the clean base stage (OS + Desktop + VNC/noVNC only)
FROM biop/biop-vnc-base:0.3.1

USER root

# Install dependencies required by Debian Trixie and the installer/runtime
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    unzip \
    ca-certificates \
    libgl1 \
    libglx0 \
    libglib2.0-0 \
    libxtst6 \
    libxi6 \
    libxrender1 \
    libxrandr2 \
    libxcursor1 \
    libxinerama1 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/mib_installer

# 1. Download MIB2 Linux installer zip from GitHub Releases
# 2. Verify SHA-256 checksum
# 3. Unzip and run ONLY the .install binary in silent mode
# 4. Clean up temporary files
RUN curl -sSL -L "https://github.com/Ajaxels/MIB2/releases/download/v2.93/MIB2_Linux_293_R2024b.zip" -o MIB2_Linux.zip && \
    echo "e1df31471aeab00a2dc92951fe3ab9566a9cd6867826450fa8974963650d663f  MIB2_Linux.zip" | sha256sum -c - && \
    unzip MIB2_Linux.zip && \
    chmod +x MIB2_Linux.install && \
    ./MIB2_Linux.install -mode silent -agreeToLicense yes -destinationFolder /opt/MIB && \
    rm -rf /tmp/mib_installer

# Set up a launcher that resolves the MATLAB runtime path and starts MIB as the
# desktop user. This avoids the common issue where the package is installed as root
# but the app is launched as a non-root desktop session.
RUN mkdir -p /opt/icons /home/biop/Desktop && \
    printf '#!/bin/bash\nset -e\nMCR_DIR="/opt/MIB/runtime/v97"\nif [ ! -d "$MCR_DIR" ]; then\n  found=$(find /opt/MIB -maxdepth 3 -type d -name "v*" 2>/dev/null | head -n 1 || true)\n  if [ -n "$found" ]; then\n    MCR_DIR="$found"\n  fi\nfi\nif [ -d "$MCR_DIR" ]; then\n  export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$MCR_DIR"\nfi\nexec /opt/MIB/application/run_MIB.sh "$MCR_DIR"\n' > /opt/icons/start_mib.sh && \
    chmod +x /opt/icons/start_mib.sh && \
    # set chown and chmod for all necessary folders so the desktop user can launch MIB
    chown -R biop:biop /opt/MIB /opt/icons /home/biop/Desktop && \
    chmod -R a+rwx /opt/MIB /opt/icons /home/biop/Desktop && \
    chmod a+rwx /opt/icons/start_mib.sh && \
    printf '[Desktop Entry]\n\
Version=2.93\n\
Type=Application\n\
Name=Microscopy Image Browser\n\
GenericName=MIB\n\
Comment=Microscopy Image Browser\n\
Categories=Education;Science;ImageProcessing;\n\
Exec=/opt/icons/start_mib.sh\n\
TryExec=/opt/icons/start_mib.sh\n\
Terminal=false\n\
StartupNotify=true\n\
Icon=/opt/MIB/application/mib_icon.png\n' > /home/biop/Desktop/mib.desktop && \
    chmod a+rwx /home/biop/Desktop/mib.desktop && \
    chown biop:biop /home/biop/Desktop/mib.desktop

USER biop
WORKDIR /home/biop