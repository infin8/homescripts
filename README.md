This is my own location that I used to store my scripts for my home Linux server. This is configured for my setup, but welcome any questions.

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

My gmedia starts up items in order:
1) [rclone mount](https://github.com/animosity22/homescripts/blob/master/systemd/gmedia-rclone.service)
2) [mergerfs mount](https://github.com/animosity22/homescripts/blob/master/systemd/gmedia-mergerfs.service) which runs the [script](https://github.com/animosity22/homescripts/blob/master/scripts/mergerfs_mount)
3) [find command](https://github.com/animosity22/homescripts/blob/master/systemd/gmedia-find.service) which runs the [script](https://github.com/animosity22/homescripts/blob/master/scripts/GD_find)

### Known Issues
- Plex Playback
  - Apple TV (4th generation)
    - Direct Play Stuttering
      - This happens on both vfs-read-chunk-size and cache. Cache masks this more so since the chunks remain local. If you turn "Allow Direct Play", this will fix the issue as it will Direct Stream instead. This can be worked around by using Infuse / MRMC / Emby
      - RClone debug log shows the files being rapidly opened and closed as the client seems to request part of the file and close it out.
