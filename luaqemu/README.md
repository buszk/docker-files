# LuaQEMU [![Actions Status](https://github.com/buszk/docker-files/workflows/luaqemu-docker/badge.svg)](https://github.com/buszk/docker-files/actions)

### Build on your own
`docker build . -tag luaqemu-img`

### Use the docker hub image
`docker pull buszk/luaqemu-docker:lastest`

### What to do afterward
As the author of LuaQEMU stated, documentation does not exist. 

You should refer to `/luaqemu/hw/arm/luaqemu` for hints of using the code.

Example code used in the [blog](https://comsecuris.com/blog/posts/luaqemu_bcm_wifi/) is in `/luaqemu/examples/bcm4358` directory.
