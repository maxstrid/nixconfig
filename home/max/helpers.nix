{ pkgs, lib }:

# Mainly taken from https://github.com/rengare/dotfiles/blob/main/nix/helpers.nix 
let
  nixGLWrap = pkg:
    pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/${pkg.pname}; do
        wrapped_bin=$out/bin/$(basename $bin)
        echo "exec ${lib.getExe pkgs.nixgl.nixGLIntel} $bin \$@" > $wrapped_bin
        chmod +x $wrapped_bin
      done
      for bin in ${pkg}/bin/*; do
        [ ! -f $out/bin/$(basename $bin) ] && cp "$bin" "$out/bin/"
        echo a
      done
    '';
in
{
  nixGLWrap = nixGLWrap;
}
