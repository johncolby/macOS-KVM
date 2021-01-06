#!/bin/bash

# Reattach GPU to host
virsh nodedev-reattach pci_0000_0a_00_1
virsh nodedev-reattach pci_0000_0a_00_0

# Load AMD driver
modprobe amdgpu

# Restart display manager
systemctl start display-manager
