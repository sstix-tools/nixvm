{
  description = "nixvm - Nix-backed Java, Ruby, and Python version manager";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  outputs = { self, nixpkgs }:
    let
      systems = [
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system nixpkgs.legacyPackages.${system});
    in
    {
      packages = forAllSystems (system: pkgs: rec {
        default = nixvm;
        nixvm = pkgs.stdenvNoCC.mkDerivation {
          pname = "nixvm";
          version = "1.0.0";
          src = ./.;

          nativeBuildInputs = [ pkgs.makeWrapper ];

          installPhase = ''
            mkdir -p $out/bin $out/share/zsh/site-functions
            install -D -m 0755 bin/nixvm $out/bin/nixvm
            install -D -m 0644 completion/_nixvm $out/share/zsh/site-functions/_nixvm
            wrapProgram $out/bin/nixvm \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.coreutils pkgs.jq ]}
          '';

          meta = {
            description = "Nix-backed Java, Ruby, and Python version manager";
            mainProgram = "nixvm";
            platforms = [ "aarch64-darwin" ];
          };
        };
      });

      apps = forAllSystems (system: pkgs: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/nixvm";
          meta.description = "Nix-backed Java, Ruby, and Python version manager";
        };
      });
    };
}
