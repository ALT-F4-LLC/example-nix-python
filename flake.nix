{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
    {
      packages.${system}.default = pkgs.poetry2nix.mkPoetryApplication {
        projectDir = self;
      };

      devShells.${system}.default = pkgs.mkShellNoCC {
        shellHook = "echo Welcome to your Nix-powered development environment!"; # Shell commands executed when entering the shell

        IS_NIX_AWESOME = "YES!"; # We can set an environment variable either like *this* or inside the shellHook above

        packages = with pkgs; [
          (poetry2nix.mkPoetryEnv { projectDir = self; })
          neofetch # Added a non-python dependency to the devshell
        ];
      };

      apps.${system}.default = {
        program = "${self.packages.${system}.default}/bin/start";
        type = "app";
      };
    };
}
