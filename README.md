# nixos-theia

A flake providing Theia packages for NixOS users.

## Goal

- one part: [nix numtide/devshell](https://github.com/numtide/devshell)
- one part: [Nix](https://nixos.org)
- one part: [Theia IDE](https://theia-ide.org)

The idea would be that projects can offer things in pieces:
- a bit of nix specifying the development toolchain needed to build
- a bit of nix specifying various configurations of Theia + plugins
- a bit of user-specified Nix containining further Theia customizations

Then, yay Nix, we can just compose the Nix files to build reliable, yet
customizable development environments.

## TODO

- Push this and post on NixOS Discourse to see if others are interested
- Get theia building at all with Nix
  - too many node->nix tools
    - node2nix
    - the other node2nix
    - pnpm2nix
    - yarn2nix
    - etc
    - (Theia uses 'yarn' and seems to have some sort of custom build step for its plugins, hopefully that's not a pain)
  - I'm bad at node stuff, and worse with node+nix, need to get someone to advise
- experiment with best ways to run it:
  - shared kubernetes cluster for (costs/corporate needs)
  - easy ability to launch NixOS cloud instances for privacy/power/etc


## Stretch Goal

- Kubernetes:
  - hack the CRIO runtime, near the CRI boundary, probably
    - make it realize Nix store paths and guarantee them available
    - mount the store paths into a new set of namespaces
  - aka, "Kubernetes containers" without having to ever deal with a "container" image.
  - this probably makes more sense split-out as a separate project (then Kata could be experimented with)

## WIP Notes

- I tried yarn2nix first (https://github.com/nix-community/yarn2nix)
- ran it, didn't do much else?
