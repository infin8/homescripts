# README.md

This is my own location that I used to store my scripts for my home Linux server. This is configured for my setup, but welcome any questions.

## Home Configuration

- Verizon Gigabit FIOS
- Google Drive with an Encrypted Media Folder
- Debian Stretch 9.5
- Intel(R) Core(TM) i7-7700 CPU @ 3.60GHz
- 32 GB of Memory
- 250 GB SSD Storage for my root
- 6TB mirrored for staging
- rTorrent, NZBGet, Sonarr, Radarr and Ombi all run locally on my mergerfs mount that allows hard linking of files.

## Rclone configuration

I use a combination of mergerfs and rclone to keep a local mount that is always written to first and my second mount point is my rclone Google Drive.

        /data/local (local disk)
        /data/rclone (rclone mount)
    /gmedia

They all get mounted up via my systemd scripts for [gmedia-service](https://github.com/animosity22/homescripts/blob/master/rclone-systemd/gmedia.service).

My gmedia starts up items in order:
1) [rclone mount](https://github.com/animosity22/homescripts/blob/master/rclone-systemd/gmedia-rclone.service)
2) [mergerfs mount](https://github.com/animosity22/homescripts/blob/master/rclone-systemd/gmedia.mount)
3) [find command](https://github.com/animosity22/homescripts/blob/master/rclone-systemd/gmedia-find.service) which justs caches the directory and file structure and provides me an output of the structure

## [mergerfs@github](https://github.com/trapexit/mergerfs)

I use mergerfs over unionfs as it provides me the ability to define a file system to always write first to.

I use the following options:

```bash
Options = use_ino,hard_remove,auto_cache,sync_read,allow_other,category.action=all,category.create=ff
```

Two important items:

- sync_read as rclone is default built with this and is required for proper streaming
- category.action=all,category.create=ff says to always create directories / files on the first listed mount point and for my configuration that is my /data/mounts/local

## Scheduled Nightly Uploads

I moved my files to my GD every ngiht via a cron job and an [upload cloud](https://github.com/animosity22/homescripts/blob/master/scripts/upload_cloud) script. This leverages an [excludes](https://github.com/animosity22/homescripts/blob/master/scripts/excludes) file which gets rid of partials and my torrent directory.

## Known Issues

- Plex Playback
  - Apple TV (4th generation)
    - Direct Play Stuttering
      - This happens on both vfs-read-chunk-size and cache. Cache masks this more so since the chunks remain local. If you turn off "Allow Direct Play", this will fix the issue as it will Direct Stream instead. Using another player such as Infuse / Emby works as well as they do not exihibit the Direct Play issue. I will retest this once TVOS 12 hits to see if it has been fixed or not.
      - RClone debug log shows the files being rapidly opened and closed as the client seems to request part of the file and close it out.
