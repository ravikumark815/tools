#!/bin/bash
# CentOS/RHEL System Cleanup Script
# Run as: sudo bash centos-cleanup.sh

echo ">>>--- check-update ---<<<"
sudo yum check-update

echo ">>>--- update ---<<<"
sudo yum update -y

echo ">>>--- upgrade ---<<<"
sudo yum upgrade -y

echo ">>>--- autoremove ---<<<"
sudo yum autoremove -y

echo ">>>--- dnf update (if available) ---<<<"
if command -v dnf &> /dev/null
then
    sudo dnf update -y
    sudo dnf upgrade -y
    sudo dnf autoremove -y
    sudo dnf clean all
fi

echo ">>>--- clean all ---<<<"
sudo yum clean all -y

echo ">>>--- removing old kernels (leave last 2) ---<<<"
if command -v package-cleanup &>/dev/null; then
    sudo package-cleanup --oldkernels --count=2 -y
fi

echo ">>>--- cleaning journal logs (keep 2 weeks) ---<<<"
sudo journalctl --vacuum-time=2weeks

echo ">>>--- cleaning /tmp and user trash ---<<<"
sudo rm -rf /tmp/*
rm -rf ~/.local/share/Trash/*

echo ">>>--- cleaning /var/log (compressed and empty logs) ---<<<"
sudo find /var/log -type f -name "*.gz" -delete
sudo find /var/log -type f -name "*.1" -delete
sudo find /var/log -type f -empty -delete

echo ">>>--- checking disk usage ---<<<"
df -h

echo "System cleanup complete!"