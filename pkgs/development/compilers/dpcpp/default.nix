{ lib
, stdenv
, fetchurl
, fetchpatch
, cmake
, pkg-config
, ncurses
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
    cmake
    pkg-config
    ncurses
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
      -a install \
      -c \
      --eula accept \
      --install-dir $out
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
