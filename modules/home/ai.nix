_: {
  flake.homeModules.ai = {pkgs, ...}: let
    optionalAttrs = pkgs.lib.optionalAttrs;
  in {
    services.ollama =
      {
        enable = true;
        environmentVariables = {OLLAMA_CONTEXT_LENGTH = "64000";};
      }
      // optionalAttrs pkgs.stdenv.hostPlatform.isLinux {
        acceleration = "cuda";
        package = pkgs.ollama-cuda;
        # package = pkgs.ollama-cuda.overrideAttrs (old: {
        #   # The nested llama.cpp build does not inherit the parent CMake flags,
        #   # and the CUDA setup hook gives it a malformed toolkit root.
        #   preBuild = ''
        #     export CUDAToolkit_ROOT="${pkgs.cudaPackages.cuda_nvcc}"
        #     ${old.preBuild}
        #   '';
        # });
      };
  };
}
