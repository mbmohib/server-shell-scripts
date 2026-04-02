#!/bin/bash

# Configuration
SWAP_SIZE="2G"
SWAP_FILE="/swapfile"

setup_swap() {
    # Check if swap already exists
    if swapon --show | grep -q "$SWAP_FILE"; then
        echo "⚠️  Swap file already exists and is active. Skipping."
        return
    fi

    echo "Creating swap file ($SWAP_SIZE)..."
    sudo fallocate -l $SWAP_SIZE $SWAP_FILE

    echo "Setting correct permissions..."
    sudo chmod 600 $SWAP_FILE

    echo "Setting up swap space..."
    sudo mkswap $SWAP_FILE

    echo "Enabling swap..."
    sudo swapon $SWAP_FILE

    # Make swap permanent across reboots
    if ! grep -q "$SWAP_FILE" /etc/fstab; then
        echo "Making swap permanent..."
        echo "$SWAP_FILE none swap sw 0 0" | sudo tee -a /etc/fstab
    fi

    # Tune swappiness (default is 60, lower = use swap less aggressively)
    # 10 is ideal for a server — only uses swap when really needed
    echo "Tuning swappiness to 10..."
    sudo sysctl vm.swappiness=10
    if ! grep -q "vm.swappiness" /etc/sysctl.conf; then
        echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf
    fi

    echo "✅ Swap setup complete."
}

verify_swap() {
    echo ""
    echo "📊 Swap status:"
    swapon --show
    echo ""
    free -h
}

# Main
setup_swap
verify_swap
