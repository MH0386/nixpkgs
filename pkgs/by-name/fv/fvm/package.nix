{
  buildDartApplication,
  installShellFiles,
  clang,
  pkg-config,
  gtk3,
  cmake,
  fetchFromGitHub,
}:

buildDartApplication rec {
  pname = "fvm";
  version = "3.2.1";
  src = fetchFromGitHub {
    owner = "leoafarias";
    repo = pname;
    rev = version;
    hash = "sha256-i7sJRBrS5qyW8uGlx+zg+wDxsxgmolTMcikHyOzv3Bs=";
  };
  autoPubspecLock = src + "/pubspec.lock";
  nativeBuildInputs = [
    installShellFiles
    clang
    pkg-config
    gtk3
    cmake
    installShellFiles
  ];
  shellHook = ''
    export PKG_CONFIG_PATH=${gtk3.dev}/lib/pkgconfig
    export LD_LIBRARY_PATH=${gtk3.out}/lib:$LD_LIBRARY_PATH
  '';
  dontUseCmakeConfigure = true;
  postInstall = ''
    export HOME=$TMPDIR
    installShellCompletion --cmd fvm \
      --bash <($out/bin/fvm --generate-shell-completion bash) \
      --fish <($out/bin/fvm --generate-shell-completion fish) \
      --zsh <($out/bin/fvm --generate-shell-completion zsh)
  '';
}
