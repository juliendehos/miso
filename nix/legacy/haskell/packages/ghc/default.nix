pkgs:
let
  source = import ../../../../source.nix pkgs;
in
with pkgs.haskell.lib;
self: super:
{
  miso = self.callCabal2nix "miso" source.miso {};
  miso-from-html = self.callCabal2nix "miso-from-html" source.miso-from-html {};
  sample-app = self.callCabal2nix "app" source.sample-app {};

  jsaddle = self.callCabal2nix "jsaddle" "${source.jsaddle}/jsaddle" {};
  jsaddle-warp = dontCheck (self.callCabal2nix "jsaddle-warp" "${source.jsaddle}/jsaddle-warp" {});
}
