_: {
  flake.homeModules.three_d_printing = {pkgs, ...}: {
    home.packages = with pkgs; [
      # freecad-wayland
      # withNvidiaGLWorkaround routes through Mesa+Zink to fix blank 3D viewport
      # with NVIDIA proprietary GL. See: https://github.com/NixOS/nixpkgs/issues/498311
      #
      # Resizable BAR is disabled on this machine (BIOS setting), so the
      # CPU-visible VRAM heap (BAR) is only ~246MB. Zink spams allocation errors
      # during slicing when it exhausts this heap. ZINK_DEBUG=quiet suppresses
      # the non-fatal warnings. The permanent fix is enabling Resizable BAR in
      # BIOS (Advanced > PCI/PCIe settings).
      # ((bambu-studio.override
      #   {
      #     withNvidiaGLWorkaround = true;
      #   }).overrideAttrs (old: {
      #   postFixup =
      #     (old.postFixup or "")
      #     + ''
      #       wrapProgram $out/bin/bambu-studio \
      #         --set VK_ICD_FILENAMES /run/opengl-driver/share/vulkan/icd.d/nvidia_icd.json \
      #         --set ZINK_DEBUG quiet
      #     '';
      # }))
    ];
  };
}
