_: {
  flake.homeModules.three_d_printing = {pkgs, ...}: {
    home.packages = with pkgs; [
      # freecad-wayland
      ((bambu-studio.override
        {
          withNvidiaGLWorkaround = true;
        }).overrideAttrs (old: {
        # withNvidiaGLWorkaround routes through Mesa+zink, but without
        # restricting the Vulkan ICD, zink picks llvmpipe (software) instead
        # of the NVIDIA GPU, causing OOM crashes. Force the NVIDIA Vulkan ICD.
        postFixup =
          (old.postFixup or "")
          + ''
            wrapProgram $out/bin/bambu-studio \
              --set VK_ICD_FILENAMES /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json
          '';
      }))
    ];
  };
}
