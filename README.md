# PMS-Docker

Forked from Kevin McGill's excellent repository at https://github.com/kmcgill88/k-plex  Changes include migrating to the official Plex Docker image, instead of LinuxServer.IO's version.

Inspired by Plex DVR. This container has [Comskip](https://github.com/erikkaashoek/Comskip) and [PlexComskip](https://github.com/ekim1337/PlexComskip) installed to remove commercials from any DVR'd content. 

### How to use:
- [Pull pms-docker from docker](https://hub.docker.com/r/mandreko/pms-docker/) by running, `docker pull mandreko/pms-docker`
- Run the container as described by [plexinc/pms-docker](https://github.com/plexinc/pms-docker)
- Once running, go to Plex Settings, then DVR (Beta)
- DVR Settings
- Scroll to `POSTPROCESSING SCRIPT`
- Enter `/opt/PlexComskip/comskip.sh`
- Click `Save`.
- Enjoy commercial free TV!

![](https://raw.githubusercontent.com/wiki/mandreko/pms-docker/mandreko-pms-docker.png)

When DVR recordings end, `Comskip` will automatically run and the show will be added to your Plex library.
