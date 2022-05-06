{
  description = "Front page for Harvest Fruit and Veg";
  inputs.nixpkgs.url = "nixpkgs";
  outputs = { self, nixpkgs, ... }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in
      {
        defaultPackage.x86_64-linux = self.packages.x86_64-linux.harvest-front-page;
        packages.x86_64-linux.harvest-front-page =
          pkgs.stdenv.mkDerivation {
            name = "harvest-front-page";
            src = ./assets;
            installPhase = ''
              mkdir $out
              cp * $out/
            '';
            phases = [ "unpackPhase" "installPhase" ];
          };
      };
}
