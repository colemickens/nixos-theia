#!/usr/bin/env bash

(
    cd node2nix
    node2nix
    # whatever?
)

nix build .#theia --keep-failed

exit 0

(
    cd ...
)
