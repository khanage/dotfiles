{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      pkgs = pkgs.extend (_: prev: {
        # Breakpad omits fast_source_line_resolver.o from its stackwalk link targets.
        breakpad = prev.breakpad.overrideAttrs {
          postConfigure = ''
            substituteInPlace Makefile \
              --replace-fail '$(src_processor_microdump_stackwalk_LDADD) $(LIBS)' '$(src_processor_microdump_stackwalk_LDADD) src/processor/fast_source_line_resolver.o $(LIBS)' \
              --replace-fail '$(src_processor_minidump_stackwalk_LDADD) $(LIBS)' '$(src_processor_minidump_stackwalk_LDADD) src/processor/fast_source_line_resolver.o $(LIBS)'
          '';
        };
      });
      settings = builtins.fromJSON (builtins.readFile ./noctalia.json);
    };
  };
}
