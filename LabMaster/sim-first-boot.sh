#!/bin/sh
ssh "$1" sudo touch /boot/flatcar/first_boot
ssh "$1" sudo rm /etc/machine-id
ssh "$1" sudo reboot