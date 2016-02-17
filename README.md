# docker-centos6-wallarm

Docker image is located at [varsy/centos6-wallarm](https://hub.docker.com/r/varsy/centos6-wallarm/).
Do not forget to put wallarm's `license.key` to `/etc/nginx-wallarm/license.key`.

There are following environment variables you need to set in order to register your node at `my.wallarm.com`:
* `WALLARM_USER` 
* `WALLARM_PASSWORD`
* `WALLARM_NODENAME`

And you could define `SLAB_ALLOC_ARENA` env variable for `wallarm-tarantool` configuration.

This image extends [SergeyZh/docker-centos6-nginx](https://github.com/SergeyZh/docker-centos6-nginx) so the main controls are described there.
