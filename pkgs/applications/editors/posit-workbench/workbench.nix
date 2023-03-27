{ lib, stdenv, fetchzip, patchelf, glibc, glib, autoPatchelfHook, makeWrapper, zlib, 
gfortran, pam, openssl_3_0, libuuid, sqlite, postgresql, sssd, bash } :
stdenv.mkDerivation rec {
  name = "posit-workbench";
  version = "rhel-2023.05.0-daily-130.pro2-x86_64";

  # Find matching version on https://dailies.rstudio.com/rstudio/
  src = fetchzip {
    url = "mirror://rstudio/session/rhel8-x86_64/rstudio-workbench-${version}.tar.gz";
    sha256 = "sha256:1lw7vi8sdbbizwmprmn3lizflmx8vgibh37b4mmiprzbjnpw3dvl";
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

    mkdir -p "$out/rstudio"
    #cp -r "$src" "$out/rstudio"
    cp -r * "$out/rstudio"
    chmod -R +w "$out/opt/rsp-session"

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
    platforms = [ "x86_64-linux" ];
    maintainers = [ "nviets" ];
  };
}
