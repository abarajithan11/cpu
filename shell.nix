{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    gcc
    gnumake
    gtkwave
    python3
    verilator
    zlib
  ];
}
