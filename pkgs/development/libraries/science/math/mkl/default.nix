{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, dpcpp
, tbb
}:

stdenv.mkDerivation rec {
  pname = "onemkl";
  version = "2023.1";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "oneMKL";
    rev = "632cb000c6bc5cee41cc6be0e3e3ea86041dca62";
    hash = "sha256-TLmUU3djf9YfvIMyzAsAlSLNk3Ox2Tln6TGAMkMBJ/E=";
  };

  nativeBuildInputs = [
    cmake
    dpcpp
    tbb
  ];

  # Fix build with modern gcc
  # In member function 'void std::__atomic_base<_IntTp>::store(__int_type, std::memory_order) [with _ITp = bool]',
  #NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [ "-Wno-error=stringop-overflow" ] ++
    # Workaround for gcc-12 ICE when using -O3
    # https://gcc.gnu.org/PR108854
    #lib.optionals (stdenv.cc.isGNU && stdenv.isx86_32) [ "-O2" ];

  meta = with lib; {
    description = "Intel-Optimized Math Library for Numerical Computing ";
    homepage = "https://www.intel.com/content/www/us/en/developer/tools/oneapi/onemkl.html";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice tmarkus nviets ];
  };
}
