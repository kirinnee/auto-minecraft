{ nixpkgs ? import <nixpkgs> { } }:
let pkgs = import ./packages.nix { inherit nixpkgs; }; in
with pkgs;
{
  system = [
    coreutils
    gnugrep
    jq
  ];

  dev = [
    pls
    go-task
    terraform
    ansible
  ];

  lint = [
    terraform-docs
    pre-commit
    nixpkgs-fmt
    prettier
    shfmt
    shellcheck
  ];


}
