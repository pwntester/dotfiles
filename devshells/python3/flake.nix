{
  description = "Demo Nix dev environment";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";

    # 3.12.0 release
    python_dep.url = "github:NixOS/nixpkgs/e2b8feae8470705c3f331901ae057da3095cea10";
  };

  outputs = { self, flake-utils, python_dep }@inputs :
    flake-utils.lib.eachDefaultSystem (system:
    let
      python_dep = inputs.python_dep.legacyPackages.${system};
    in
    {
      devShells.default = python_dep.mkShell {
        packages = [
          python_dep.python312
        ];

        shellHook = ''
          python --version
          exec zsh
          tmux set-option -ag status-right " PYTHON3"
        '';
      };
    });
}
