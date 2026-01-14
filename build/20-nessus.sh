#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

###############################################################################
# Installing Nessus Vulnerability Scanner
###############################################################################
# This script downloads and installs Tenable Nessus from the official source.
# Note: Nessus requires an activation code to function properly.
# Users will need to register at https://www.tenable.com/products/nessus/nessus-essentials
# to obtain a free Essentials license (up to 16 IPs) or purchase a Professional license.
###############################################################################

echo "::group:: Installing Nessus Vulnerability Scanner"

# Create temporary directory for downloads
NESSUS_TEMP_DIR="/tmp/nessus-install"
mkdir -p "${NESSUS_TEMP_DIR}"
cd "${NESSUS_TEMP_DIR}"

# Nessus version to install
# Using Fedora 38 build which is compatible with Fedora-based systems
NESSUS_VERSION="10.11.1"
NESSUS_FILENAME="Nessus-${NESSUS_VERSION}-fc38.x86_64.rpm"
NESSUS_URL="https://www.tenable.com/downloads/api/v2/pages/nessus/files/${NESSUS_FILENAME}"

echo "Downloading Nessus ${NESSUS_VERSION} for Fedora..."

# Download Nessus using curl with the official API endpoint
curl --request GET \
  --url "${NESSUS_URL}" \
  --output "${NESSUS_FILENAME}" \
  --fail \
  --silent \
  --show-error \
  --location

# Check if file was downloaded successfully
if [ -f "${NESSUS_FILENAME}" ] && [ -s "${NESSUS_FILENAME}" ]; then
    echo "Installing Nessus RPM package..."
    
    # Install Nessus
    rpm -ivh "${NESSUS_FILENAME}"
    
    # Enable Nessus service (will start on first boot)
    systemctl enable nessusd.service
    
    echo "Nessus installed successfully!"
    echo "=================================================="
    echo "IMPORTANT: Nessus Post-Installation Steps"
    echo "=================================================="
    echo "1. After first boot, access Nessus at: https://localhost:8834"
    echo "2. Complete the setup wizard"
    echo "3. Register for a free license at: https://www.tenable.com/products/nessus/nessus-essentials"
    echo "4. Enter your activation code in the setup wizard"
    echo "5. Wait for plugins to download (this may take 20-30 minutes)"
    echo ""
    echo "Nessus Essentials is free for home use and covers up to 16 IPs."
    echo "For professional use, consider Nessus Professional."
    echo "=================================================="
else
    echo "=================================================="
    echo "WARNING: Nessus download failed!"
    echo "=================================================="
    echo "Nessus may require manual installation."
    echo ""
    echo "To install Nessus manually after system deployment:"
    echo "1. Run: ujust install-nessus"
    echo "   OR"
    echo "2. Visit: https://www.tenable.com/downloads/nessus"
    echo "3. Download: ${NESSUS_FILENAME}"
    echo "4. Install with: sudo rpm -ivh ${NESSUS_FILENAME}"
    echo "5. Start service: sudo systemctl enable --now nessusd"
    echo "6. Access: https://localhost:8834"
    echo "=================================================="
fi

# Clean up temporary directory
cd /
rm -rf "${NESSUS_TEMP_DIR}"

echo "::endgroup::"
