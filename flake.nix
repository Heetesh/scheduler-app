# {
#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#     flake-utils.url = "github:numtide/flake-utils";
#   };

#   outputs = inputs:
#     inputs.flake-utils.lib.eachDefaultSystem (system:
#       let
#         pkgs = import inputs.nixpkgs {
#           inherit system;
#           #config.allowUnfree = true;
#         };

#         devShells.default = pkgs.mkShell {
#           packages = with pkgs; [
#             #BUILD
#             python312
#             poetry
#             sqlite
#             openssl
#             nodejs
#             yarn

#             #DEV
#             nixd
#             nixpkgs-fmt
#             nixfmt
#           ];

#           shellHook = ''
#             if [ "''${NO_FLAKE_SHELL_SWITCH:-}" != "1" ]; then
#               # If zsh is available, set it as default shell
#               if command -v zsh &> /dev/null; then
#                 export SHELL=${pkgs.zsh}/bin/zsh
#               fi
#             fi
#           '';
#         };
#       in { inherit devShells; });
# }
{
  description = "Dev environment for Vue.js + FastAPI project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry.url = "github:nix-community/poetry2nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      poetry,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        pythonEnv = pkgs.python311.withPackages (
          ps: with ps; [
            (fastapi.overridePythonAttrs (old: {
              doCheck = false;
            }))
            (uvicorn.overridePythonAttrs (old: {
              doCheck = false;
            }))
            httpx
            black
            # add more Python packages as needed
          ]
        );
      in
      {
        devShell = pkgs.mkShell {
          buildInputs = [
            pythonEnv
            pkgs.nodejs_22
            pkgs.yarn
            pkgs.git
            pkgs.poetry
          ];

          shellHook = ''
            echo "✨ Welcome to the Vue.js + FastAPI dev shell"
            echo "🔧 Python: $(python --version)"
            echo "🌐 Node: $(node --version)"
          '';
        };
      }
    );
}
