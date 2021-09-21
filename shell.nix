let
  pkgs = import <nixpkgs> { };

  prepack = pkgs.writeShellScriptBin "prepack" ''
    npm run compile

    rm -rf artifacts
    mkdir -p artifacts
    cp build/contracts/*.json artifacts
  '';

  prepublish = pkgs.writeShellScriptBin "prepublish" ''
    npm config set sign-git-tag true
    npm version patch
  '';
in
pkgs.stdenv.mkDerivation {
  name = "shell";
  buildInputs = [
    pkgs.nodejs-14_x
    pkgs.nixpkgs-fmt
    prepack
    prepublish
  ];

  shellHook = ''
    export PATH=$( npm bin ):$PATH
    # keep it fresh
    npm install
  '';
}
