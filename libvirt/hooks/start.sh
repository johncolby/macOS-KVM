#!/bin/bash

# Stop display manager
systemctl stop display-manager

# Unload AMD driver
modprobe -r amdgpu

# Detach GPU from host
virsh nodedev-detach pci_0000_09_00_0
virsh nodedev-detach pci_0000_09_00_1
