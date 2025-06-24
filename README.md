# tools
A growing collection of practical command-line scripts and utilities to make every developer’s life easier.  
From system cleanup to workflow automation, these tools save time, reduce hassle, and let you focus on what matters: building great software.

| Script | Purpose | Sample Usage |
|---|---|---|
| [`ubuntu-cleanup.sh`](./ubuntu-cleanup.sh) | Update, upgrade, autoremove, and clean Ubuntu systems | `sudo bash ubuntu-cleanup.sh` |
| [`centos-cleanup.sh`](./centos-cleanup.sh) | Update, upgrade, autoremove, and clean CentOS/RHEL systems | `sudo bash centos-cleanup.sh` |
| [`windows-cleanup.bat`](./windows-cleanup.bat) | Cleans up Windows temp files, recycle bin, thumbnails, and more | Run as Admin: double-click or `cmd /c windows-cleanup.bat` |
| [`windows-update-reset.bat`](./windows-update-reset.bat) | Fully resets Windows Update components (services, cache, registry, DLLs) | Run as Admin: double-click or `cmd /c windows-update-reset.bat` |
| [`url-decode.py`](./url-decode.py) | Decode (and encode) URL strings | `python url-decode.py 'hello%20world'` |
| [`mm.py`](./mm.py) | Prevent system sleep by simulating activity | `python mm.py 540` |
| [`ubuntu-setup.sh`](./ubuntu-setup.sh) | Sets up Ubuntu for dev: updates system, installs essentials, sets up Python/pip, SSH key, and clones/configures dotfiles from [dot-files](https://github.com/ravikumark815/dot-files) | `bash ubuntu-setup.sh you@email.com` |