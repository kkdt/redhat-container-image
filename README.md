# redhat-container-image

> The steps below performed on Red Hat 8.10 Enterprise Linux

## 1 Overview

See [Chapter 19. Building container images with Buildah][redhat-documentation].

## 2 Base Packages

- ansible-core
- bash
- coreutils
- ncurses
- shadow-utils
- vi

## 3 Quickstart

1. Download the Red Hat full installation image (examples below)
    - [Red Hat 9.5][rhel9.5]
    - [Red Hat 10.1][rhel10.1]
2. Mount DVD 
    ```
    sudo mount ~/Data/iso/rhel-9.5-x86_64-dvd.iso /mnt/
    ```
3. A [yum.repo](yum.repos.d/9.5/yum.repo) is provided as an example for Red Hat 9.5
4. Execute the build
    ```
    buildah unshare ./build.sh
    ```
5. Run the container
    ```
    podman run -it --rm localhost/sample-redhat:dev /bin/bash
    ```

[//]: Links

[redhat-buildah-unshare]: https://www.redhat.com/en/blog/buildah-unshare-command
[redhat-documentation]: https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/assembly_building-container-images-with-buildah
[rhel9.5]: https://access.redhat.com/downloads/content/479/ver=/rhel---9/9.5/x86_64/product-software
[rhel10.1]: https://access.redhat.com/downloads/content/479/ver=/rhel---10/10.1/x86_64/product-software