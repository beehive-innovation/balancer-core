let
 pkgs = import <nixpkgs> {};

 prepack = pkgs.writeShellScriptBin "prepack" ''
 npm run compile

 mkdir artifacts
 cp build/contracts/*.json artifacts
 '';

 pack = pkgs.writeShellScriptBin "pack" ''
 npm pack
 '';

 publish = pkgs.writeShellScriptBin "publish" ''
 npm publish ./balancer-core-0.0.7.tgz --access public
 '';
in
pkgs.stdenv.mkDerivation {
 name = "shell";
 buildInputs = [
  pkgs.nodejs-14_x
  prepack
  pack
  publish
 ];

 shellHook = ''
  export PATH=$( npm bin ):$PATH
  # keep it fresh
  npm install
 '';
}