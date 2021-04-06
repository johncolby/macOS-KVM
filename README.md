# macOS KVM

## Background

The purpose of this repository is to share my personalized (i.e. *cleaned up*, streamlined) QEMU KVM Hackintosh configuration using libvirt and OpenCore. This is an updated snapshot of what I am currently running on my relatively simple mini-ITX build.

Like many people, I began with general purpose KVM Hackintosh repositories such as:

- [kholia/OSX-KVM: Run macOS on QEMU/KVM. With OpenCore + Big Sur support now! Only commercial (paid) support is available.](https://github.com/kholia/OSX-KVM)
- [foxlet/macOS-Simple-KVM: Tools to set up a quick macOS VM in QEMU, accelerated by KVM.](https://github.com/foxlet/macOS-Simple-KVM)

However, in trying to be as universal as possible, these prebuilt options leave you with a lot of extra configuration that will not be applicable to any particular setup. This also makes it more difficult to maintain the build, and can lead to a slower and overall less stable setup.

I kept reading/learning, eventually coming across some of the excellent more targeted resources out there:

- [** Hackintosh ** Tips to make a bare metal MacOS - VM Engine (KVM) - Unraid](https://forums.unraid.net/topic/84430-hackintosh-tips-to-make-a-bare-metal-macos/)
- [macOS / Hackintosh – Nicholas Sherlock](https://www.nicksherlock.com/category/macos/)
- [Leoyzen/KVM-Opencore: Opencore Configuration of KVM Hackintosh with tweaks](https://github.com/Leoyzen/KVM-Opencore)
- [Pavo-IM/Proxintosh: MacOS install using Proxmox on AMD system with all system components passthrough to MacOS](https://github.com/Pavo-IM/Proxintosh)

Starting from my initial bloated configuration, I have slowly been able to trim down the unneeded components, toward the goal of maintaining the bare minimum configuration sufficient to achieve a functional build. As such, **this configuration will not work on your system out of the box**. Instead, it is here to show examples of the *possible* changes you might explore for your own rig.

## Hardware info

[johncolby's Completed Build - Ryzen 5 3600 3.6 GHz 6-Core, M1 Mini ITX Tower - PCPartPicker](https://pcpartpicker.com/b/ZGn7YJ)

<details>
  <summary>Ubuntu linux host details</summary>

```
❯ inxi -Faz
System:    Kernel: 5.8.0-18-generic x86_64 bits: 64 compiler: N/A
           parameters: BOOT_IMAGE=/vmlinuz-5.8.0-18-generic root=/dev/mapper/vgubuntu-root ro modprobe.blacklist=amdgpu
           quiet splash amd_iommu=on iommu=pt vt.handoff=7
           Console: tty 2 dm: GDM3 3.36.3 Distro: Ubuntu 20.04.1 LTS (Focal Fossa)
Machine:   Type: Desktop Mobo: Gigabyte model: B550I AORUS PRO AX v: x.x serial: <filter> UEFI: American Megatrends
           v: F10 date: 09/18/2020
CPU:       Topology: 6-Core model: AMD Ryzen 5 3600 bits: 64 type: MT MCP arch: Zen family: 17 (23) model-id: 71 (113)
           stepping: N/A microcode: 8701021 L2 cache: 3072 KiB
           flags: avx avx2 lm nx pae sse sse2 sse3 sse4_1 sse4_2 sse4a ssse3 svm bogomips: 86237
           Speed: 2467 MHz min/max: 2200/3600 MHz boost: enabled Core speeds (MHz): 1: 2762 2: 2478 3: 2195 4: 2195
           5: 1863 6: 2196 7: 2196 8: 2196 9: 2157 10: 2722 11: 1862 12: 2193
           Vulnerabilities: Type: itlb_multihit status: Not affected
           Type: l1tf status: Not affected
           Type: mds status: Not affected
           Type: meltdown status: Not affected
           Type: spec_store_bypass mitigation: Speculative Store Bypass disabled via prctl and seccomp
           Type: spectre_v1 mitigation: usercopy/swapgs barriers and __user pointer sanitization
           Type: spectre_v2 mitigation: Full AMD retpoline, IBPB: conditional, STIBP: conditional, RSB filling
           Type: srbds status: Not affected
           Type: tsx_async_abort status: Not affected
Graphics:  Device-1: Advanced Micro Devices [AMD/ATI] Navi 10 [Radeon RX 5600 OEM/5600 XT / 5700/5700 XT]
           vendor: Sapphire Limited driver: vfio-pci v: 0.2 bus ID: 0a:00.0 chip ID: 1002:731f
           Display: server: X.org 1.20.8 driver: ati,fbdev unloaded: modesetting,radeon,vesa compositor: gnome-shell
           tty: 124x39
           Message: Advanced graphics data unavailable in console. Try -G --display
Audio:     Device-1: Advanced Micro Devices [AMD/ATI] Navi 10 HDMI Audio driver: vfio-pci v: 0.2 bus ID: 0a:00.1
           chip ID: 1002:ab38
           Device-2: Advanced Micro Devices [AMD] Starship/Matisse HD Audio vendor: Gigabyte driver: vfio-pci v: 0.2
           bus ID: 0c:00.4 chip ID: 1022:1487
           Sound Server: ALSA v: k5.8.0-18-generic
Network:   Device-1: Realtek RTL8125 2.5GbE vendor: Gigabyte driver: r8125 v: 9.003.05-NAPI port: f000 bus ID: 06:00.0
           chip ID: 10ec:8125
           IF: eno1 state: up speed: 1000 Mbps duplex: full mac: <filter>
           Device-2: Intel Wi-Fi 6 AX200 driver: iwlwifi v: kernel port: f000 bus ID: 07:00.0 chip ID: 8086:2723
           IF: wlp7s0 state: down mac: <filter>
           IF-ID-1: br0 state: up speed: 1000 Mbps duplex: unknown mac: <filter>
           IF-ID-2: virbr0 state: down mac: <filter>
           IF-ID-3: virbr0-nic state: down mac: <filter>
           IF-ID-4: vnet0 state: unknown speed: 10 Mbps duplex: full mac: <filter>
Drives:    Local Storage: total: 931.51 GiB used: 649.87 GiB (69.8%)
           SMART Message: Required tool smartctl not installed. Check --recommends
           ID-1: /dev/nvme0n1 vendor: Samsung model: SSD 970 EVO Plus 1TB size: 931.51 GiB block size: physical: 512 B
           logical: 512 B speed: 31.6 Gb/s lanes: 4 serial: <filter> rev: 2B2QEXM7 scheme: GPT
Partition: ID-1: / raw size: 929.32 GiB size: 913.74 GiB (98.32%) used: 649.43 GiB (71.1%) fs: ext4 dev: /dev/dm-1
           ID-2: /boot raw size: 732.0 MiB size: 704.5 MiB (96.24%) used: 409.6 MiB (58.1%) fs: ext4 dev: /dev/nvme0n1p2
           ID-3: swap-1 size: 976.0 MiB used: 30.8 MiB (3.2%) fs: swap swappiness: 60 (default)
           cache pressure: 100 (default) dev: /dev/dm-2
Sensors:   System Temperatures: cpu: 45.4 C mobo: N/A
           Fan Speeds (RPM): N/A
Info:      Processes: 355 Uptime: 2h 42m Memory: 31.31 GiB used: 25.84 GiB (82.5%) Init: systemd v: 245 runlevel: 5
           target: graphical.target Compilers: gcc: 9.3.0 alt: 9 Shell: zsh v: 5.8 running in: tty 2 (SSH) inxi: 3.0.38
```
```
❯ for g in `find /sys/kernel/iommu_groups/* -maxdepth 0 -type d | sort -V`; do
    echo "IOMMU Group ${g##*/}:"
    for d in $g/devices/*; do
        echo -e "\t$(lspci -nns ${d##*/})"
    done;
done;
IOMMU Group 0:
  00:01.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 1:
  00:01.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge [1022:1483]
IOMMU Group 2:
  00:01.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge [1022:1483]
IOMMU Group 3:
  00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 4:
  00:03.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 5:
  00:03.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge [1022:1483]
IOMMU Group 6:
  00:04.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 7:
  00:05.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 8:
  00:07.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 9:
  00:07.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Internal PCIe GPP Bridge 0 to bus[E:B] [1022:1484]
IOMMU Group 10:
  00:08.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 11:
  00:08.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Internal PCIe GPP Bridge 0 to bus[E:B] [1022:1484]
IOMMU Group 12:
  00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:790b] (rev 61)
  00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:790e] (rev 51)
IOMMU Group 13:
  00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse Device 24: Function 0 [1022:1440]
  00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse Device 24: Function 1 [1022:1441]
  00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse Device 24: Function 2 [1022:1442]
  00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse Device 24: Function 3 [1022:1443]
  00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse Device 24: Function 4 [1022:1444]
  00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse Device 24: Function 5 [1022:1445]
  00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse Device 24: Function 6 [1022:1446]
  00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse Device 24: Function 7 [1022:1447]
IOMMU Group 14:
  01:00.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM4360 802.11ac Wireless Network Adapter [14e4:43a0] (rev 03)
IOMMU Group 15:
  02:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ee]
  02:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] Device [1022:43eb]
  02:00.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43e9]
  03:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
  03:04.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
  03:08.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
  03:09.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
  05:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller SM981/PM981/PM983 [144d:a808]
  06:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller [10ec:8125] (rev 05)
  07:00.0 Network controller [0280]: Intel Corporation Wi-Fi 6 AX200 [8086:2723] (rev 1a)
IOMMU Group 16:
  08:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Upstream Port of PCI Express Switch [1002:1478] (rev c1)
IOMMU Group 17:
  09:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Downstream Port of PCI Express Switch [1002:1479]
IOMMU Group 18:
  0a:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 [Radeon RX 5600 OEM/5600 XT / 5700/5700 XT] [1002:731f] (rev c1)
IOMMU Group 19:
  0a:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 HDMI Audio [1002:ab38]
IOMMU Group 20:
  0b:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Function [1022:148a]
IOMMU Group 21:
  0c:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Reserved SPP [1022:1485]
IOMMU Group 22:
  0c:00.1 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Cryptographic Coprocessor PSPCPP [1022:1486]
IOMMU Group 23:
  0c:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 Host Controller [1022:149c]
IOMMU Group 24:
  0c:00.4 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse HD Audio Controller [1022:1487]
```
</details>

<details>
  <summary>macOS guest details</summary>

![Screen Shot 2021-04-05 at 8 24 09 PM](https://user-images.githubusercontent.com/473295/113655207-3c680e80-964e-11eb-9629-4ebd3df97f1a.png)
![Screen Shot 2021-04-05 at 8 24 34 PM](https://user-images.githubusercontent.com/473295/113655264-56a1ec80-964e-11eb-8350-791e9b84d1c8.png)
![Screen Shot 2021-04-05 at 8 27 41 PM](https://user-images.githubusercontent.com/473295/113655293-615c8180-964e-11eb-989d-7a631861a613.png)
</details>

## Optimizations 

### OpenCore

- Remove tons of unneeded legacy drivers (`HiiDatabase.efi`, `NvmExpressDxe.efi`, `OpenUsbKbDxe.efi`, `Ps2KeyboardDxe.efi`, `Ps2MouseDxe.efi`, `UsbMouseDxe.efi`, `VBoxHfs.efi`, `XhciDxe.efi`, `mXHCD.kext`).
- Remove tons of legacy quirks/workarounds from OC `config.plist` (many more can be cut out!).
- Remove some OC bells/whistles that I don't need and therefore just cause clutter (`AudioDxe.efi`, `OpenCanopy.efi`, `OpenShell.efi`, `CrScreenshotDxe.efi`).
- Remove `SSDT-DTGP.aml` (not needed; can use the [PMPM method](https://dortania.github.io/Getting-Started-With-ACPI/Universal/plug-methods/manual.html) instead for enabling power management in `SSDT-PLUG.aml`).
- Remove `SSDT-EC.aml` (not needed; `AppleBusPowerController` attaches fine without it under Catalina, and KVM OVMF firmware doesn't have a real EC that needs to be turned off).
- Remove `SSDT-USBX.aml` (not needed; USB power properties can be added to USB port mapping kext (`USBmap.kext`).
- Remove `WhateverGreen.kext` (not needed for my needs with AMD 5700XT, although probably never hurts).
- Remove `MCEReporterDisabler.kext` (not getting kernel panics, so not needed).
- Remove `SSDT-PLUG.aml` (not needed for CPU power management, which the hypervisor manages).
- Personalized `USBmap.kext` created with [`USBMap`](https://github.com/corpnewt/USBMap).

### Libvirt

- Clean up the messy PCI configuration (can cut down on the number of controllers to what is needed, delete the PCIe to PCI legacy bridge, etc.).
- Remove default emulated USB 3 controller.
- Remove additional unneeded USB 1/2 controllers.