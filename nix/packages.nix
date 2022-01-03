{ nixpkgs ? import <nixpkgs> { } }:
let pkgs = {
  atomi = (
    with import (fetchTarball "https://github.com/kirinnee/test-nix-repo/archive/refs/tags/v7.0.0.tar.gz");
    {
      inherit pls;
    }
  );
  "Unstable 18th September 2021" = (
    with import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/9f75aabfb06346e7677fc3ad53cc9b6669eead61.tar.gz") { };
    {
      inherit
        terraform-docs
        pre-commit
        git
        shfmt
        shellcheck
        nixpkgs-fmt
        bash
        coreutils
        go-task
        gnugrep
        ansible
        jq
        terraform
        nodejs;
      prettier = nodePackages.prettier;
    }
  );
  "Unstable 3rd January 2022" = (
    with import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/9f75aabfb06346e7677fc3ad53cc9b6669eead61.tar.gz") { };
    {
      inherit
        awscli2;
    }
  );
}; in
with pkgs;
pkgs."Unstable 18th September 2021" // pkgs.atomi // pkgs."Unstable 3rd January 2022"
