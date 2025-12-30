FROM localhost/sample-redhat:dev

RUN <<EOF
set -e
useradd --create-home --comment "Local development" developer
EOF

USER developer
WORKDIR /workspace
CMD ["/bin/bash"]