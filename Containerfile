# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# FROM ghcr.io/ublue-os/akmods:bazzite-42 AS akmods
# FROM ghcr.io/ublue-os/akmods-extra:bazzite-42 AS akmods-extra

# Base Image
FROM ghcr.io/ublue-os/bazzite-gnome:stable

## Other possible base images include:
# FROM ghcr.io/ublue-os/bazzite:latest
# FROM ghcr.io/ublue-os/bluefin-nvidia:stable
# 
# ... and so on, here are more base images
# Universal Blue Images: https://github.com/orgs/ublue-os/packages
# Fedora base image: quay.io/fedora/fedora-bootc:41
# CentOS base images: quay.io/centos-bootc/centos-bootc:stream10

### MODIFICATIONS
## make modifications desired in your image and install packages by modifying the build.sh script
## the following RUN directive does all the things required to run "build.sh" as recommended.

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
#    --mount=type=bind,from=akmods,src=/kernel-rpms,dst=/tmp/kernel-rpms \
#    --mount=type=bind,from=akmods-extra,src=/rpms,dst=/tmp/akmods-extra-rpms \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit
    
### LINTING
## Verify final image and contents are correct.
RUN bootc container lint