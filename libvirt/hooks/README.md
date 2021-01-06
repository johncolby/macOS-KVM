# Single GPU Passthrough

Here are the steps needed to enable single GPU passthrough. Of course this will vary depending on kernel, OS, and hardware.

1. Enable legacy/CSM support in host EFI (needed at least on my particular hardware). 
	- [Explaining CSM, efifb=off, and Setting the Boot GPU Manually - The Passthrough POST](https://passthroughpo.st/explaining-csm-efifboff-setting-boot-gpu-manually/)

1. Add libvirt XML element for GPU vBIOS ROM.
	- [VGA Bios Collection: Sapphire RX 5700 XT 8 GB | TechPowerUp](https://www.techpowerup.com/vgabios/213915/sapphire-rx5700xt-8192-190811)
	- Note that AppArmor only allows libvirt permission to certin directories by default. 
	- For example:

	```
	    <hostdev mode='subsystem' type='pci' managed='yes'>
	      <driver name='vfio'/>
	      <source>
	        <address domain='0x0000' bus='0x0a' slot='0x00' function='0x0'/>
	      </source>
	      <rom file='/usr/share/vgabios/Sapphire.RX5700XT.8192.190811.rom'/>
	      <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0' multifuultifunction='on'/>
	    </hostdev>
	```

1. Set up `libvirt` hooks.
    - [Howto: Libvirt Automation Using VFIO-Tools Hook Helper - The Passthrough POST](https://passthroughpo.st/simple-per-vm-libvirt-hooks-with-the-vfio-tools-hook-helper/)
    - [PassthroughPOST/VFIO-Tools: A collection of tools and scripts that aim to make PCI passthrough a little easier.](https://github.com/PassthroughPOST/VFIO-Tools)
    - Examples in this repository: [`start.sh`](start.sh) and [`revert.sh`](revert.sh)
