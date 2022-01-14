#!/bin/bash

# Checking the boot mode.
echo "Checking the computer's Boot mode. (BIOS/UEFI)"
if ls /sys/firmware/efi/efivars
then echo "\nUEFI"
else echo "\nBIOS"
fi

# To check for active internet connection
echo "\nChecking for Internet Connection.\n"
if echo "\n" && ping -c 3 archlinux.org
then echo "\nActive Internet Connection"
else echo "\nInternet Connection Problem"
fi

# To update System clock
echo "\nUpdating the Time-Zone."
if timedatectl set-timezone Asia/Kolkata
then echo "\nTime-Zone set to Asia/Kolkata"
else echo "\nTime-Zone not set properly"
fi

# Partitioning the disks
echo "\nStart Partitioning the Disks."
fdisk /dev/sda

# Format the partitions
echo "\n Formatting the partitions with their respective File Systems, now."
if mkfs.ext4 /dev/sda1
then echo "\nDisk successfully formatted."
else echo "\nError reported. Check manually."
fi

# Mounting the formatted file systems
echo "\nMounting the File Systems."
if mount /dev/sda1 /mnt
then echo "\nFile System mounted at /mnt."
else echo "\nDidn't mount. Check manually."
fi

# Updating mirrorlist by replacing existing one, with custom mirrorlist
echo "\nCloning custom mirrorlist to have nearby and fastest mirrors available.\n"
git clone https://github.com/Guy-Ritchie/arch-mirrorlist.git
cd arch-mirrorlist
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old
if mv mirrorlist /etc/pacman.d/
then echo "\nGit clone, successful. Custom Mirrorlist copied to local machine."
else echo "\nCouldn't clone repo. Check manually for errors."
fi

# Pacstrap command to install necessary base packages
echo "\nInstalling base packages to System.\n"
pacstrap /mnt base linux linux-firmware vim networkmanager zsh grub base-devel sudo alsamixer alsa pulseaudio

# Configuring Fstab file
echo "\nConfiguring the fstab file."
genfstab -U /mnt >> /mnt/etc/fstab
echo "\nThe resulting fstab file is : \n\n"
cat /mnt/etc/fstab

# Chrooting into the base installation at /mnt
echo "\n\n"Chrooting into base install."
arch-chroot /mnt
