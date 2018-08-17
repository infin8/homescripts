This is just a location for me as I wanted a spot to keep all my plex / media related scripts that I am using.

These are the settings that I found most useful.

### Home Configuration

- Verizon Gigabit FIOS
- Google Drive with an Encrypted Media Folder
- Ubuntu 18.04 LTS
- Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz
- 32 GB of Memory
- 200 GB SSD Storage for my root
- 6TB mirrored ZFS for staging

### Rclone configuration
I use a combination of mergerfs and rclone to keep a local mount that is always written to first and my second mount point is my rclone Google Drive.

        /data/local (local disk)
        /GD (rclone mount)
    /gmedia

They all get mounted up via my systemd scripts for [gmedia-service](https://github.com/animosity22/homescripts/blob/master/systemd/gmedia.service).
