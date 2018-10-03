# Ubuntu

I've recently switched to using Ubuntu for web development.

This project will setup Ubuntu 18.04 with some essential apps for me to use.

A seperate script will set it up for web development.

## Code

I had to increase the number of files that can be watched: https://code.visualstudio.com/docs/setup/linux#_visual-studio-code-is-unable-to-watch-for-file-changes-in-this-large-workspace-error-enospc

added `fs.inotify.max_user_watches=524288` to the end of the `/etc/sysctl.conf` file and applied with `sudo sysctl -p`. 

## Git

Installed GitKraken as it seems to have more features than Giggle.

## Terminal

Installed Hyper as it seems newer than any typical "Linux" terminal.

