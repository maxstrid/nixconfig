{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      llama-cpp = super.llama-cpp.override {
        rcpSupport = true;
      };
    })
  ];

  environment.systemPackages = [
    pkgs.llama-cpp
  ];
}
