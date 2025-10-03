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
System:
  Kernel: 6.14.0-29-generic arch: x86_64 bits: 64 compiler: gcc v: 13.3.0 clocksource: tsc
    avail: hpet,acpi_pm parameters: BOOT_IMAGE=/vmlinuz-6.14.0-29-generic
    root=/dev/mapper/vgubuntu-root ro quiet splash vfio-pci.ids=14e4:43a0 vt.handoff=7
  Console: pty pts/0 DM: GDM3 v: 46.2 Distro: Ubuntu 24.04.3 LTS (Noble Numbat)
Machine:
  Type: Desktop Mobo: Gigabyte model: B550I AORUS PRO AX serial: <superuser required>
    uuid: <superuser required> UEFI: American Megatrends LLC. v: F20d date: 09/02/2024
CPU:
  Info: model: AMD Ryzen 5 3600 bits: 64 type: MT MCP arch: Zen 2 gen: 3 level: v3 note: check
    built: 2020-22 process: TSMC n7 (7nm) family: 0x17 (23) model-id: 0x71 (113) stepping: 0
    microcode: 0x8701034
  Topology: cpus: 1x cores: 6 tpc: 2 threads: 12 smt: enabled cache: L1: 384 KiB
    desc: d-6x32 KiB; i-6x32 KiB L2: 3 MiB desc: 6x512 KiB L3: 32 MiB desc: 2x16 MiB
  Speed (MHz): avg: 2639 high: 3802 min/max: 550/4208 boost: enabled scaling:
    driver: amd-pstate-epp governor: powersave cores: 1: 3591 2: 3802 3: 1723 4: 3654 5: 3099
    6: 1723 7: 3593 8: 1723 9: 1723 10: 1723 11: 3592 12: 1723 bogomips: 86242
  Flags: avx avx2 ht lm nx pae sse sse2 sse3 sse4_1 sse4_2 sse4a ssse3 svm
  Vulnerabilities:
  Type: gather_data_sampling status: Not affected
  Type: ghostwrite status: Not affected
  Type: indirect_target_selection status: Not affected
  Type: itlb_multihit status: Not affected
  Type: l1tf status: Not affected
  Type: mds status: Not affected
  Type: meltdown status: Not affected
  Type: mmio_stale_data status: Not affected
  Type: reg_file_data_sampling status: Not affected
  Type: retbleed mitigation: untrained return thunk; SMT enabled with STIBP protection
  Type: spec_rstack_overflow mitigation: Safe RET
  Type: spec_store_bypass mitigation: Speculative Store Bypass disabled via prctl
  Type: spectre_v1 mitigation: usercopy/swapgs barriers and __user pointer sanitization
  Type: spectre_v2 mitigation: Retpolines; IBPB: conditional; STIBP: always-on; RSB filling;
    PBRSB-eIBRS: Not affected; BHI: Not affected
  Type: srbds status: Not affected
  Type: tsx_async_abort status: Not affected
Graphics:
  Device-1: AMD Navi 10 [Radeon RX 5600 OEM/5600 XT / 5700/5700 XT] vendor: Sapphire
    driver: vfio-pci v: N/A alternate: amdgpu arch: RDNA-1 code: Navi-1x process: TSMC n7 (7nm)
    built: 2019-20 pcie: gen: 4 speed: 16 GT/s lanes: 16 bus-ID: 09:00.0 chip-ID: 1002:731f
    class-ID: 0300
  Display: server: X.org v: 1.21.1.11 with: Xwayland v: 23.2.6 driver: X: loaded: radeon
    unloaded: fbdev,modesetting,vesa gpu: vfio-pci tty: 128x45
  API: EGL v: 1.5 platforms: device: 0 drv: swrast surfaceless: drv: swrast
    inactive: gbm,wayland,x11
  API: OpenGL v: 4.5 vendor: mesa v: 25.0.7-0ubuntu0.24.04.2 note: console (EGL sourced)
    renderer: llvmpipe (LLVM 20.1.2 256 bits)
Audio:
  Device-1: AMD Navi 10 HDMI Audio driver: vfio-pci alternate: snd_hda_intel pcie: gen: 4
    speed: 16 GT/s lanes: 16 bus-ID: 09:00.1 chip-ID: 1002:ab38 class-ID: 0403
  Device-2: AMD Starship/Matisse HD Audio vendor: Gigabyte driver: vfio-pci
    alternate: snd_hda_intel pcie: gen: 4 speed: 16 GT/s lanes: 16 bus-ID: 0b:00.4
    chip-ID: 1022:1487 class-ID: 0403
  API: ALSA v: k6.14.0-29-generic status: kernel-api tools: alsactl,alsamixer,amixer
  Server-1: PipeWire v: 1.0.5 status: active with: 1: pipewire-pulse status: active
    2: wireplumber status: active 3: pipewire-alsa type: plugin tools: pw-cat,pw-cli,wpctl
Network:
  Device-1: Broadcom BCM4360 802.11ac Dual Band Wireless Network Adapter vendor: Apple
    driver: vfio-pci v: N/A modules: bcma pcie: speed: Unknown lanes: 63 link-max: gen: 1
    speed: 2.5 GT/s bus-ID: 01:00.0 chip-ID: 14e4:43a0 class-ID: 0280
  Device-2: Realtek RTL8125 2.5GbE vendor: Gigabyte driver: r8169 v: kernel pcie: gen: 2
    speed: 5 GT/s lanes: 1 port: f000 bus-ID: 05:00.0 chip-ID: 10ec:8125 class-ID: 0200
  IF: eno1 state: up speed: 2500 Mbps duplex: full mac: <filter>
  Device-3: Intel Wi-Fi 6 AX200 driver: iwlwifi v: kernel pcie: gen: 2 speed: 5 GT/s lanes: 1
    bus-ID: 06:00.0 chip-ID: 8086:2723 class-ID: 0280
  IF: wlp6s0 state: down mac: <filter>
  IF-ID-1: br-57ba6366edbb state: up speed: 10000 Mbps duplex: unknown mac: <filter>
  IF-ID-2: br0 state: up speed: 10000 Mbps duplex: unknown mac: <filter>
  IF-ID-3: docker0 state: down mac: <filter>
  IF-ID-4: veth5e79caf state: up speed: 10000 Mbps duplex: full mac: <filter>
  IF-ID-5: virbr0 state: down mac: <filter>
  IF-ID-6: vnet0 state: unknown speed: 10000 Mbps duplex: full mac: <filter>
  Info: services: NetworkManager, sshd, systemd-timesyncd, wpa_supplicant
Bluetooth:
  Device-1: Intel AX200 Bluetooth driver: btusb v: 0.8 type: USB rev: 2.0 speed: 12 Mb/s lanes: 1
    mode: 1.1 bus-ID: 1-8:4 chip-ID: 8087:0029 class-ID: e001
  Report: hciconfig ID: hci1 rfk-id: 1 state: down bt-service: enabled,running rfk-block:
    hardware: no software: yes address: <filter>
  Info: acl-mtu: 1021:4 sco-mtu: 96:6 link-policy: rswitch sniff link-mode: peripheral accept
Drives:
  Local Storage: total: 931.51 GiB used: 694.29 GiB (74.5%)
  SMART Message: Required tool smartctl not installed. Check --recommends
  ID-1: /dev/nvme0n1 maj-min: 259:0 vendor: Samsung model: SSD 970 EVO Plus 1TB size: 931.51 GiB
    block-size: physical: 512 B logical: 512 B speed: 31.6 Gb/s lanes: 4 tech: SSD serial: <filter>
    fw-rev: 2B2QEXM7 temp: 56.9 C scheme: GPT
Partition:
  ID-1: / raw-size: 929.32 GiB size: 913.66 GiB (98.31%) used: 693.86 GiB (75.9%) fs: ext4
    dev: /dev/dm-1 maj-min: 252:1 mapped: vgubuntu-root
  ID-2: /boot raw-size: 732 MiB size: 703.1 MiB (96.05%) used: 433 MiB (61.6%) fs: ext4
    dev: /dev/nvme0n1p2 maj-min: 259:2
  ID-3: /boot/efi raw-size: 512 MiB size: 511 MiB (99.80%) used: 6.1 MiB (1.2%) fs: vfat
    dev: /dev/nvme0n1p1 maj-min: 259:1
Swap:
  Kernel: swappiness: 60 (default) cache-pressure: 100 (default) zswap: no
  ID-1: swap-1 type: partition size: 976 MiB used: 508 KiB (0.1%) priority: -2 dev: /dev/dm-2
    maj-min: 252:2 mapped: vgubuntu-swap_1
Sensors:
  System Temperatures: cpu: 59.5 C mobo: 50.0 C
  Fan Speeds (rpm): N/A
Info:
  Memory: total: 32 GiB available: 31.25 GiB used: 25.42 GiB (81.3%)
  Processes: 322 Power: uptime: 19m states: freeze,mem,disk suspend: deep avail: s2idle
    wakeups: 0 hibernate: platform avail: shutdown, reboot, suspend, test_resume image: 12.47 GiB
    services: power-profiles-daemon,upowerd Init: systemd v: 255 target: graphical (5)
    default: graphical tool: systemctl
  Packages: 2606 pm: dpkg pkgs: 2585 libs: 1135 tools: apt,apt-get pm: snap pkgs: 21 Compilers:
    gcc: 13.3.0 alt: 9/11/12 Shell: Zsh v: 5.9 running-in: pty pts/0 (SSH) inxi: 3.3.34
```
```
IOMMU Group 0:
	00:00.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Root Complex [1022:1480]
IOMMU Group 1:
	00:01.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 2:
	00:01.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge [1022:1483]
IOMMU Group 3:
	00:01.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge [1022:1483]
IOMMU Group 4:
	00:02.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 5:
	00:03.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 6:
	00:03.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse GPP Bridge [1022:1483]
IOMMU Group 7:
	00:04.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 8:
	00:05.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 9:
	00:07.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 10:
	00:07.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Internal PCIe GPP Bridge 0 to bus[E:B] [1022:1484]
IOMMU Group 11:
	00:08.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Host Bridge [1022:1482]
IOMMU Group 12:
	00:08.1 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Internal PCIe GPP Bridge 0 to bus[E:B] [1022:1484]
IOMMU Group 13:
	00:14.0 SMBus [0c05]: Advanced Micro Devices, Inc. [AMD] FCH SMBus Controller [1022:790b] (rev 61)
	00:14.3 ISA bridge [0601]: Advanced Micro Devices, Inc. [AMD] FCH LPC Bridge [1022:790e] (rev 51)
IOMMU Group 14:
	00:18.0 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data Fabric: Device 18h; Function 0 [1022:1440]
	00:18.1 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data Fabric: Device 18h; Function 1 [1022:1441]
	00:18.2 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data Fabric: Device 18h; Function 2 [1022:1442]
	00:18.3 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data Fabric: Device 18h; Function 3 [1022:1443]
	00:18.4 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data Fabric: Device 18h; Function 4 [1022:1444]
	00:18.5 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data Fabric: Device 18h; Function 5 [1022:1445]
	00:18.6 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data Fabric: Device 18h; Function 6 [1022:1446]
	00:18.7 Host bridge [0600]: Advanced Micro Devices, Inc. [AMD] Matisse/Vermeer Data Fabric: Device 18h; Function 7 [1022:1447]
IOMMU Group 15:
	01:00.0 Network controller [0280]: Broadcom Inc. and subsidiaries BCM4360 802.11ac Dual Band Wireless Network Adapter [14e4:43a0] (rev 03)
IOMMU Group 16:
	02:00.0 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset USB 3.1 XHCI Controller [1022:43ee]
	02:00.1 SATA controller [0106]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset SATA Controller [1022:43eb]
	02:00.2 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] 500 Series Chipset Switch Upstream Port [1022:43e9]
	03:04.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
	03:08.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
	03:09.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD] Device [1022:43ea]
	04:00.0 Non-Volatile memory controller [0108]: Samsung Electronics Co Ltd NVMe SSD Controller SM981/PM981/PM983 [144d:a808]
	05:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd. RTL8125 2.5GbE Controller [10ec:8125] (rev 05)
	06:00.0 Network controller [0280]: Intel Corporation Wi-Fi 6 AX200 [8086:2723] (rev 1a)
IOMMU Group 17:
	07:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Upstream Port of PCI Express Switch [1002:1478] (rev c1)
IOMMU Group 18:
	08:00.0 PCI bridge [0604]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 XL Downstream Port of PCI Express Switch [1002:1479]
IOMMU Group 19:
	09:00.0 VGA compatible controller [0300]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 [Radeon RX 5600 OEM/5600 XT / 5700/5700 XT] [1002:731f] (rev c1)
IOMMU Group 20:
	09:00.1 Audio device [0403]: Advanced Micro Devices, Inc. [AMD/ATI] Navi 10 HDMI Audio [1002:ab38]
IOMMU Group 21:
	0a:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse PCIe Dummy Function [1022:148a]
IOMMU Group 22:
	0b:00.0 Non-Essential Instrumentation [1300]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Reserved SPP [1022:1485]
IOMMU Group 23:
	0b:00.1 Encryption controller [1080]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse Cryptographic Coprocessor PSPCPP [1022:1486]
IOMMU Group 24:
	0b:00.3 USB controller [0c03]: Advanced Micro Devices, Inc. [AMD] Matisse USB 3.0 Host Controller [1022:149c]
IOMMU Group 25:
	0b:00.4 Audio device [0403]: Advanced Micro Devices, Inc. [AMD] Starship/Matisse HD Audio Controller [1022:1487]
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
- Remove `MCEReporterDisabler.kext` (not getting kernel panics, so not needed).
- Remove `SSDT-PLUG.aml` (not needed for CPU power management, which the hypervisor manages).
- Personalized `USBmap.kext` created with [`USBMap`](https://github.com/corpnewt/USBMap).

### Libvirt

- Clean up the messy PCI configuration (can cut down on the number of controllers to what is needed, delete the PCIe to PCI legacy bridge, etc.).
- Remove default emulated USB 3 controller.
- Remove additional unneeded USB 1/2 controllers.
