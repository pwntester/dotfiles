{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/698fd43e541a6b8685ed408aaf7a63561018f9f8";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = with pkgs; mkShell {
          buildInputs = [

            # You can set the major version of Node.js to a specific one instead
            # of the default version
            # nodejs
            # nodejs-22_x

            # Comment out one of these to use an alternative package manager.
            # yarn
            # pnpm
            # bun

            nodejs_22

            nodePackages.node-gyp
            nodePackages.node-gyp-build
            nodePackages.prettier
            nodePackages.typescript
            nodePackages.typescript-language-server
            # nodePackages.tree-sitter
            # nodePackages.tree-sitter-javascript
            # nodePackages.tree-sitter-typescript
          ];

          shellHook = ''
            echo "node `${pkgs.nodejs}/bin/node --version`"
            exec zsh
          '';
        };
      }
    );
}
