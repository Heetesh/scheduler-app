{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    inputs:
    inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          #config.allowUnfree = true;
        };

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            #BUILD
            python312
            poetry
            sqlite
            openssl
            nodejs
            yarn

            #DEV
            nixd
            nixpkgs-fmt
            nixfmt
          ];

          shellHook = ''
            if [ "''${NO_FLAKE_SHELL_SWITCH:-}" != "1" ]; then
              # If zsh is available, set it as default shell
              if command -v zsh &> /dev/null; then
                export SHELL=${pkgs.zsh}/bin/zsh
              fi
            fi
          '';
        };
      in
      {
        inherit devShells;
      }
    );
}
