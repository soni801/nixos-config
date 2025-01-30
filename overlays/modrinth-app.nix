final: prev: {
  modrinth-app = prev.modrinth-app.overrideAttrs (oldAttrs: {
    buildInputs = oldAttrs.buildInputs or [ ] ++ [ prev.pkgs.makeWrapper ];
    postInstall = oldAttrs.postInstall or "" + ''
      wrapProgram $out/bin/ModrinthApp \
        --set WEBKIT_DISABLE_DMABUF_RENDERER 1 \
        --set LIBGL_ALWAYS_SOFTWARE 1 \
        --set GDK_BACKEND x11
    '';
  });
}
