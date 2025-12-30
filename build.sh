#!/bin/bash

# debug flag
set -x

__directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__buildir=${__directory}/build
__name="sample-redhat"
__scratchmnt=""

buildah from --name "${__name}" scratch

__scratchmnt=$(buildah mount ${__name})

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
  redhat-release vi vim bash coreutils shadow-utils

echo "Committing container image: ${__name}"
buildah commit ${__name} ${__name}:dev

echo "Removing container"
buildah rm ${__name}

echo "done."