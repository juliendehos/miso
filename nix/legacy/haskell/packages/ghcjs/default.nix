options: pkgs:
let
  source = import ../../../../source.nix pkgs;
in
with pkgs.haskell.lib;
with pkgs.lib;
self: super:
{
  inherit (pkgs.haskell.packages.ghc865) hpack;
  sample-app-js = self.callCabal2nix "app" source.sample-app {};
  jsaddle = self.callCabal2nix "jsaddle" "${source.jsaddle}/jsaddle" {};
  jsaddle-warp = dontCheck (self.callCabal2nix "jsaddle-warp" "${source.jsaddle}/jsaddle-warp" {});
  # servant = self.callCabal2nix "servant" "${source.servant}/servant" {};
  miso-flatris = self.callCabal2nix "flatris" source.miso-flatris {};
  miso-plane =
    let
      miso-plane = self.callCabal2nix "miso-plane" source.miso-plane {};
    in
      pkgs.runCommand "miso-plane" {} ''
         mkdir $out
         cp -rv ${source.miso-plane}/public/images $out
         cp ${miso-plane}/bin/client.jsexe/* $out
         rm $out/index.html
         cp -v ${source.miso-plane}/public/index.html $out
      '';
  miso-2048 = import source.miso-2048 { inherit pkgs; inherit (self) miso; };
  miso-snake = self.callCabal2nix "miso-snake" source.miso-snake {};
  mkDerivation = args: super.mkDerivation (args // { doCheck = false; });
  doctest = null;
  miso-examples = (self.callCabal2nix "miso-examples" source.examples {}).overrideDerivation (drv: {
    postInstall = ''
      mkdir -p $out/bin/mario.jsexe/imgs
      cp -r ${drv.src}/mario/imgs $out/bin/mario.jsexe/
    '';
  });
  miso-prod = self.callCabal2nixWithOptions "miso" source.miso "-fproduction" {};
  miso = self.callCabal2nix "miso" source.miso {};
}
