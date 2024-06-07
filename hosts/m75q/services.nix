{ pkgs, ... }:

{
  nixpkgs.overlays = [
    (self: super: {
      llama-cpp = super.llama-cpp.override {
        rpcSupport = true;
      };
    })
  ];

  environment.systemPackages = [
    pkgs.llama-cpp
  ];
}
