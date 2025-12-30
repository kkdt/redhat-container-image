#!/bin/bash

# debug flag
#set -x

__directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__buildir=${__directory}/build
__name="sample-redhat"
__scratchmnt=""

# Step 1: Initialize empty working container
buildah from --name "${__name}" scratch

# Step 2: Confirm container is running
buildah ps

# Step 3: Mount and save container path to a variable
__scratchmnt=$(buildah mount ${__name})

# Sep 4: Confirm container mount path
echo "Container mount path: ${__scratchmnt}"

# Step 5: Install packages within the container image mount path the provided yum.rep to the local DVD mount
rm -rf ${__buildir}/cache/dnf ${__buildir}/log && mkdir -p ${__buildir}/cache/dnf ${__buildir}/log \
  && dnf install -y --releasever=9 \
  --config ${__directory}/dnf.conf \
  --disableplugin=subscription-manager \
  --setopt=reposdir=${__directory}/yum.repos.d/9.5 \
  --installroot=${__scratchmnt} \
  --setopt=cachedir=${__buildir}/cache/dnf \
  --setopt=tsflags=nocontexts \
  --setopt=tsflags=nodocs \
  --setopt=group_package_types=mandatory \
  --setopt=install_weak_deps=false \
  redhat-release ansible-core bash coreutils dnf ncurses shadow-utils vi yum yum-utils

# Step 6: Commit the container image
echo "Committing container image: ${__name}"
buildah commit ${__name} ${__name}:dev

# Step 7: Remove working container
echo "Removing container"
buildah rm ${__name}

# Step 8: Print image history
podman image history ${__name}:dev

echo "done."