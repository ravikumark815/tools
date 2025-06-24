#!/bin/bash
# Ubuntu System Cleanup Script
# Run as: sudo bash ubuntu-cleanup.sh

echo ">>>--- update ---<<<"
sudo apt-get update -y

echo ">>>--- upgrade ---<<<"
sudo apt-get upgrade -y

echo ">>>--- dist-upgrade ---<<<"
sudo apt-get dist-upgrade -y

echo ">>>--- full-upgrade ---<<<"
sudo apt full-upgrade -y

echo ">>>--- autoremove ---<<<"
sudo apt-get autoremove -y

echo ">>>--- autoclean ---<<<"
sudo apt-get autoclean -y

echo ">>>--- clean ---<<<"
sudo apt clean -y

echo ">>>--- removing old kernels (optional) ---<<<"
# Remove old kernels, keep only the latest two
sudo apt --purge autoremove

echo ">>>--- cleaning thumbnail cache ---<<<"
rm -rf ~/.cache/thumbnails/*

echo ">>>--- cleaning journal logs (old, keep 2 weeks) ---<<<"
sudo journalctl --vacuum-time=2weeks

echo ">>>--- removing orphaned packages (deborphan) ---<<<"
if command -v deborphan &>/dev/null; then
    sudo deborphan | xargs -r sudo apt-get -y remove --purge
fi

echo ">>>--- cleaning user trash ---<<<"
rm -rf ~/.local/share/Trash/*

echo ">>>--- cleaning snap and flatpak caches (if installed) ---<<<"
if command -v snap &>/dev/null; then
    sudo snap set system refresh.retain=2
    sudo snap remove $(snap list --all | awk '/disabled/{print $1, $2}' | xargs -n2 echo)
fi
if command -v flatpak &>/dev/null; then
    flatpak uninstall --unused -y
    rm -rf ~/.var/app/*
fi

echo ">>>--- checking disk usage ---<<<"
df -h

echo ">>>--- cleaning logs in /var/log (optional) ---<<<"
sudo find /var/log -type f -name "*.gz" -delete
sudo find /var/log -type f -name "*.1" -delete
sudo find /var/log -type f -empty -delete

echo "System cleanup complete!"