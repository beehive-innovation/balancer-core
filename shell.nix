let
 pkgs = import <nixpkgs> {};

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

 publish = pkgs.writeShellScriptBin "publish" ''
  echo "//registry.npmjs.org/:_authToken=''${NPM_TOKEN}" > .npmrc

  PACKAGE_NAME=$(node -p "require('./package.json').name")
  PACKAGE_VERSION=$(node -p "require('./package.json').version")
  npm pack
  npm publish ./$PACKAGE_NAME-$PACKAGE_VERSION.tgz --access public
 '';
in
pkgs.stdenv.mkDerivation {
 name = "shell";
 buildInputs = [
  pkgs.nodejs-14_x
  prepack
  prepublish
  publish
 ];

 shellHook = ''
  export PATH=$( npm bin ):$PATH
  # keep it fresh
  npm install
 '';
}