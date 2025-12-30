# redhat-container-image

## 1 Overview

See [Chapter 19. Building container images with Buildah][redhat-documentation]. 

## 2 Development Tasks
> The steps below performed on Red Hat 8.10 

### 2.1 Download Red Hat DVD

1. Download the Red Hat full installation image (examples below)
    - [Red Hat 9.5][rhel9.5]
    - [Red Hat 10.1][rhel10.1]
2. Mount DVD 
    ```
    sudo mount ~/Data/iso/rhel-9.5-x86_64-dvd.iso /mnt/
    ```
3. A [yum.repo](yum.repos.d/9.5/yum.repo) is provided as an example for Red Hat 9.5

### 2.2 Buildah from Scratch

1. Initialize empty working container
    ```
    buildah from --isolation=chroot --name "sample-redhat" scratch
    ```
2. Confirm container is running
    ```
    # buildah ps
    CONTAINER ID  BUILDER  IMAGE ID     IMAGE NAME                       CONTAINER NAME
    01ed31ea5331     *                  scratch                          sample-redhat
    ```
3. Unshare to run shell commands in the namespaces running as **root** in the user namespace
    ```
    buildah unshare
    ```
4. Mount and save container path to a variable
    ```
    scratchmnt=$(buildah mount sample-redhat)
    ```
5. Confirm container mount path
    ```
    echo $scratchmnt
    ```
6. Initialize an RPM database within the scratch image and add the `redhat-release` package
    ```
    mkdir -p /tmp/cache/dnf /tmp/log && dnf install -y --releasever=9 \
      --config $(pwd)/dnf.conf \
      --disableplugin=subscription-manager \
      --setopt=reposdir=$(pwd)/yum.repos.d/9.5 \
      --installroot=$scratchmnt \
      --setopt=cachedir=/tmp/cache/dnf \
      redhat-release
    ```


dnf -c "${yumconf}" \
  --installroot="${target}" \
  --setopt=tsflags=nodocs \
  --setopt=group_package_types=mandatory \
  --setopt=install_weak_deps=false \
  -y install <packages>

[//]: Links

[redhat-buildah-unshare]: https://www.redhat.com/en/blog/buildah-unshare-command
[redhat-documentation]: https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/assembly_building-container-images-with-buildah
[rhel9.5]: https://access.redhat.com/downloads/content/479/ver=/rhel---9/9.5/x86_64/product-software
[rhel10.1]: https://access.redhat.com/downloads/content/479/ver=/rhel---10/10.1/x86_64/product-software