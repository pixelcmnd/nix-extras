{
  lib,
  rustPlatform,
  fetchFromGitHub,
  apple-sdk,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rift-wm";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "acsandmann";
    repo = "rift";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mgl09uli0qHPnCzmv8KRq1unNgXbmoCjfZX3tFn76Lo=";
  };

  nativeBuildInputs = [ apple-sdk ];

  useNextest = true;
  cargoHash = "sha256-MpsI9Pr4jZMQjW3WAS5r0Q+Wi8Xa470nATyduELJKW4=";

  checkFlags = [
      # CoreText uses fallback fonts in the builder, changing the expected label width.
      "--skip ui::menu_bar::layout_library_tests::labels_use_cached_text_width_for_numbers_and_names"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tiling window manager for macOS";
    homepage = "https://github.com/acsandmann/rift";
    changelog = "https://github.com/acsandmann/rift/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
  };
})
