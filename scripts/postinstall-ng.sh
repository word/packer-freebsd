#!/bin/sh

# Updated to work with latest template from FreeBSD 11 onwards

echo 'Running post-install..'

echo 'Setting up VM Tools..'
if [ "$PACKER_BUILDER_TYPE" = 'vmware-iso' ]; then
	sudo pkg install -y open-vm-tools-nox11
	echo 'vmware_guest_vmblock_enable="YES"' >> sudo tee /etc/rc.conf
	echo 'vmware_guest_vmhgfs_enable="YES"' >> sudo tee /etc/rc.conf
	echo 'vmware_guest_vmmemctl_enable="YES"' >> sudo tee /etc/rc.conf
	echo 'vmware_guest_vmxnet_enable="YES"' >> sudo tee /etc/rc.conf
	echo 'vmware_guestd_enable="YES"' >> sudo tee /etc/rc.conf
elif [ "$PACKER_BUILDER_TYPE" = 'virtualbox-iso' ]; then
	sudo pkg install -y virtualbox-ose-additions
	echo 'vboxguest_enable="YES"' >> sudo tee /etc/rc.conf
	echo 'vboxservice_enable="YES"' >> sudo tee /etc/rc.conf
else
	echo 'Unknown type of VM, not installing tools..'
fi

# Used for shared folders
echo 'nfs_client_enable="YES"' >> sudo tee /etc/rc.conf

echo 'Welcome to your zx23 virtual machine' > sudo tee /etc/motd

echo
echo 'Setting up vagrant ssh keys'
mkdir ~vagrant/.ssh
chmod 700 ~vagrant/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key" > ~vagrant/.ssh/authorized_keys
chown -R vagrant ~vagrant/.ssh
chmod 600 ~vagrant/.ssh/authorized_keys

# This causes a hang on shutdown that we cannot automatically recover from
#echo 'Patching FreeBSD..'
#freebsd-update fetch install > /dev/null

echo 'Installing packages'
echo

sudo pkg install -y py27-salt py27-pip
sudo pip install python-gnupg

echo
echo 'Post-install complete.'
