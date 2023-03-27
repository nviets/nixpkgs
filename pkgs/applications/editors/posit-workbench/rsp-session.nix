{ lib, stdenv, fetchzip, patchelf, glibc, glib, autoPatchelfHook, makeWrapper, zlib, 
gfortran, pam, openssl_3_0, libuuid, sqlite, postgresql, sssd, bash } :
stdenv.mkDerivation rec {
  name = "rsp-session";
  version = "jammy-2023.05.0-daily-92.pro3-arm64";

  # Find matching version on https://dailies.rstudio.com/rstudio/
  src = fetchzip {
    url = "mirror://rstudio/session/jammy-arm64/rsp-session-${version}.tar.gz";
    sha256 = "sha256-YhtqRS6OyfFbji2Fg7yZbUNxYDUp2gVrS7M6ZllnltU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
    glib
    gfortran
    libuuid
    openssl_3_0
    pam
    postgresql
    sqlite
    zlib
    sssd
    bash
  ];

  autoPatchelfIgnoreMissingDeps = true;

  # phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/opt"
    cp -r "$src" "$out/opt/rsp-session"
    chmod -R +w "$out/opt/rsp-session"

    # !!! Everything added to rpath needs to be removed from /opt/revr/nix-extra!!!
    substituteInPlace "$out/opt/rsp-session/bin/rsession-run"  \
      --replace "/bin/bash" "${lib.makeBinPath [ bash ]}/bash"

    wrapProgram "$out/opt/rsp-session/bin/rserver-launcher" \
      --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ sssd ]}"

    wrapProgram "$out/opt/rsp-session/bin/rsession" \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib sssd ]}"

    runHook postInstall
  '';

        # --set LD_PRELOAD "${lib.makeLibraryPath [ ncurses5 ]}/libtinfo.so.5"

  meta = {
    homepage = "https://docs.rstudio.com/rsp/integration/launcher-slurm/#8-install-rstudio-server-pro-session-components-on-slurm-compute-nodes";
    description = "RStudio Server Pro Session Components";

    license = with lib.licenses; [ unfree ];
    #platforms = [ "x86_64-linux" "aarch64-linux" "" ];
    maintainers = [ "nviets" ];
  };
}
