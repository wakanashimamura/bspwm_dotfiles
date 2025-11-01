# Arch Linux Installation Guide 

This guide provides instructions for installing Arch Linux with disk encryption using **LVM on LUKS** and **GRUB** for **UEFI systems**.

## Preface
As the installation process requires downloading packages from remote repositories, this guide assumes that you already have a working internet connection.

Most of the information here is based on the official Arch Wiki: [Arch Wiki Installation guide](https://wiki.archlinux.org/title/Installation_guide)

Last updated: **10/14/2025** Always check the Arch Wiki for the most recent and accurate information.

### Connect to the internet 

For detailed instructions see:
- [Connect to the Internet](https://wiki.archlinux.org/title/Installation_guide#Connect_to_the_internet)  
- [iwctl (wireless daemon)](https://wiki.archlinux.org/title/Iwd#iwctl)

#### Using `iwctl` for Wi-Fi

``` text
iwctl
device list
station device_name scan
station device_name get-networks
station device_name connect SSID
exit
ping google.com
```

### Partition the disks

For more details see: 
- [Partition the disks](https://wiki.archlinux.org/title/Installation_guide#Partition_the_disks)
- [Partitioning tool](https://wiki.archlinux.org/title/Partitioning#Partitioning_tools)
- [Parted](https://wiki.archlinux.org/title/Parted#Installation)
 
When recognized by the live system, disks are assigned to a block device such as /dev/sda, /dev/nvme0n1 or /dev/mmcblk0. To identify these devices, use [lsblk](https://wiki.archlinux.org/title/Device_file#lsblk) 


```bash
parted /dev/nvme0n1
mklabel gpt
mkpart "UEFI" fat32 1MiB 1025MiB
set 1 esp on
mkpart "root" ext4 1025MiB 100%
quit
```



### Encrypting the Partition

For more details see: 
- [Encrypting an entire system](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system)


```bash
cryptsetup luksFormat /dev/nvme0n1p2
cryptsetup open /dev/nvme0n1p2 cryptlvm
```

```bash
pvcreate /dev/mapper/cryptlvm
vgcreate archvg /dev/mapper/cryptlvm

lvcreate -l 100%FREE -n root archvg
```

### Format the partitions

```bash
mkfs.ext4 /dev/archvg/root
mkfs.fat -F 32 /dev/nvme0n1p1
```

### Mount the file systems

```bash
mount /dev/archvg/root /mnt
mount --mkdir /dev/nvme0n1p1 /mnt/boot
```

### Install essential packages

```bash
pacstrap -K /mnt base linux linux-firmware base-devel lvm2 dhcpcd net-tools iproute2 iwd nvim grub efibootmgr
```

### Configure the system

For more details see:  
- [Configure the system](https://wiki.archlinux.org/title/Installation_guide#Configure_the_system)
- [Users and groups](https://wiki.archlinux.org/title/Users_and_groups)

#### Fstab

```bash
genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt
```

#### Time

```bash
ln -sf /usr/share/zoneinfo/Europe/City /etc/localtime
hwclock --systohc
```

#### Localization

```bash
nvim/etc/locale.gen
```

Uncomment your locale (e.g. en_US.UTF-8)

```bash
locale-gen
```

#### Set the hostname

```bash
echo "arch" > /etc/hostname
```

#### User

```bash
# Set a secure password for the root user
passwd

# Add a new user
useradd -m -G wheel,users,video -s /bin/bash username
passwd username
```

Grant sudo permissions

```bash
sudo EDITOR=nvim visudo
```

Uncomment the following line

```bash
%wheel ALL=(ALL:ALL) ALL
```

#### Enable network services

```bash
systemctl enable dhcpcd
systemctl enable iwd.service
```

#### Edit mkinitcpio.conf

```bash
nvim /etc/mkinitcpio.conf
```

Find the line starting with HOOKS= and insert encrypt lvm2 after block, e.g.:

```bash
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block encrypt lvm2 filesystems fsck)
```

#### Then run

```bash
mkinitcpio -P
```

### Boot loader

For more details see:
- [Boot loader](https://wiki.archlinux.org/title/Arch_boot_process#Boot_loader)
- [GRUB](https://wiki.archlinux.org/title/GRUB)

```bash
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
nvim /etc/default/grub
```

Add the following line (replace with the actual UUID from blkid)

```bash
GRUB_CMDLINE_LINUX="cryptdevice=UUID=<UUID_OF_nvme0n1p2>:cryptlvm root=/dev/archvg/root"
```

Then generate the configuration

```bash
grub-mkconfig -o /boot/grub/grub.cfg
```

###  Finally, exit and reboot:

```bash
Ctrl+D
umount -R /mnt
reboot
```