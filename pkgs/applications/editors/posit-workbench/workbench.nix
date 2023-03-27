{ lib, stdenv, fetchurl, dpkg, patchelf, glibc, glib, autoPatchelfHook, makeWrapper, zlib, 
gfortran, pam, openssl_3_0, libuuid, sqlite, postgresql, sssd, bash } :
stdenv.mkDerivation rec {
  name = "posit-workbench";
  version = "jammy-2023.05.0-daily-92.pro3-arm64";

  # Find matching version on https://dailies.rstudio.com/rstudio/
  src = fetchurl {
    url = "mirror://rstudio/server/jammy-arm64/rstudio-workbench-${version}.deb";
    sha256 = "sha256-cPQWkV5hYGG3sFnQ8pXOlD4W25yR4B74ygz5zPuWNss=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
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

  #sourceRoot = ".";
  unpackPhase = ''
    dpkg-deb $src
  '';
  # phases = [ "installPhase" ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/rstudio"
    #cp -r "$src" "$out/rstudio"
    cp -r * "$out/rstudio"

    #substituteInPlace "$out/opt/rsp-session/bin/rsession-run"  \
    #  --replace "/bin/bash" "${lib.makeBinPath [ bash ]}/bash"

    #wrapProgram "$out/opt/rsp-session/bin/rserver-launcher" \
    #  --set LD_LIBRARY_PATH "${lib.makeLibraryPath [ sssd ]}"

    #wrapProgram "$out/opt/rsp-session/bin/rsession" \
    #  --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ stdenv.cc.cc.lib sssd ]}"

    runHook postInstall
  '';

        # --set LD_PRELOAD "${lib.makeLibraryPath [ ncurses5 ]}/libtinfo.so.5"

  meta = {
    homepage = "https://docs.posit.co/rsw/installation/";
    description = "Posit Workbench";

    license = with lib.licenses; [ unfree ];
    #platforms = [ "x86_64-linux" ];
    maintainers = [ "nviets" ];
  };
}
