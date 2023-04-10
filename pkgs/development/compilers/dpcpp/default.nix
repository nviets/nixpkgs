{ lib
, stdenv
, fetchurl
, fetchpatch
, cmake
, pkg-config
, ncurses
, libXau
#, qt6
#, qt6Packages
}:
stdenv.mkDerivation rec {
  pname = "oneapi";
  version = "2023.1.0";

  outputs = [ "out" "dev" ];

  src = fetchurl {
    url = "https://registrationcenter-download.intel.com/akdlm/IRC_NAS/89283df8-c667-47b0-b7e1-c4573e37bd3e/l_dpcpp-cpp-compiler_p_2023.1.0.46347_offline.sh";
    hash = "sha256-OsHBF5UBomRsuwUrBUJlVBlFc7T44jRNdpnu0D+8+h0=";
  };

  unpackPhase = ''
    echo UNPACH
  '';

  nativeBuildInputs = [
    stdenv
    stdenv.cc.cc.lib
    cmake
    pkg-config
    ncurses
    libXau
    #qt6.qtbase
    #qt6Packages.wrapQtAppsHook
  ];

  configurePhase = ''
    echo CONFIGURE
  '';

  buildPhase = ''
    echo BUILD
  '';

  installPhase = ''
    mkdir $out
    sh ${src} \
      -x -f $out
    patchelf --set-interpreter ${stdenv.cc.libc}/lib64/ld-linux-x86-64.so.2 $out/l_dpcpp-cpp-compiler_p_2023.1.0.46347_offline/bootstrapper
    patchelf --set-interpreter ${stdenv.cc.libc}/lib/ld-linux-x86-64.so.2 $out/l_dpcpp-cpp-compiler_p_2023.1.0.46347_offline/plugins/platforms/libqxcb.so
    for f in $out/l_dpcpp-cpp-compiler_p_2023.1.0.46347_offline/lib/* $out/l_dpcpp-cpp-compiler_p_2023.1.0.46347_offline/bootstrapper
    do
      patchelf --set-rpath ${stdenv.cc.cc.lib}/lib64:${stdenv.cc.cc.lib}/lib:${libXau}/lib:$out/l_dpcpp-cpp-compiler_p_2023.1.0.46347_offline/lib $f
    done

#    ldd $out/l_dpcpp-cpp-compiler_p_2023.1.0.46347_offline/bootstrapper

#    sh $out/l_dpcpp-cpp-compiler_p_2023.1.0.46347_offline/bootstrapper \
#      -s \
#      -a install \
#      --eula=accept \
#      --install-dir $out
    #cp -r * $out
  '';

  meta = with lib; {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice tmarkus ];
  };
}
