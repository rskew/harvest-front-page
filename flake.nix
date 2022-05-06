{
  description = "Splash page for Harvest Fruit and Veg";
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
        nixosModule = { domain, enableACME ? true, ACMEEmail, forceSSL ? true, ... }: {
          services.nginx.enable = true;
          services.nginx.virtualHosts.${domain} = {
            enableACME = enableACME;
            forceSSL = forceSSL;
            root = self.packages.x86_64-linux.harvest-front-page.out;
          };
          security.acme.email = if enableACME then ACMEEmail else null;
          security.acme.acceptTerms = if enableACME then true else false;
        };
      };
}
