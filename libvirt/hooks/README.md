# Single GPU Passthrough

On starting the VM, we will use `libvirt` hooks to:

1. Stop the Linux display manager. This will vary by distribution. On Ubuntu, it's GDM.

1. Unload the GPU driver. This will vary depending on if the GPU is NVIDIA or AMD.

1. Detach the GPU from the host. The PCI IDs will of course be specific to each hardware setup.

On stopping the VM, we will simply reverse the process.

Links:

- [Howto: Libvirt Automation Using VFIO-Tools Hook Helper - The Passthrough POST](https://passthroughpo.st/simple-per-vm-libvirt-hooks-with-the-vfio-tools-hook-helper/)
- [PassthroughPOST/VFIO-Tools: A collection of tools and scripts that aim to make PCI passthrough a little easier.](https://github.com/PassthroughPOST/VFIO-Tools)
- Examples in this repository: 
    - [`start.sh`](start.sh)
    - [`revert.sh`](revert.sh)
