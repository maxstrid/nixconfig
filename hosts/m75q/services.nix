{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      llama-cpp = super.llama-cpp.override {
        rocmSupport = true;
      };
    })
  ];

  environment.systemPackages = [
    pkgs.llama-cpp
  ];
}
