{ lib, stdenv, fetchFromGitHub, pkg-config
, chapel, zeromq, hdf5, arrow-cpp, iconv, libiconv, glibc, libidn2, gmp
, curl, libiconvReal}:

stdenv.mkDerivation rec {
  pname = "arkouda";
  version = "2023.10.06";

  src = fetchFromGitHub {
    owner = "Bears-R-Us";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-4ckae0X+pjP30/B7r9l1eW+iaxi2BPqyj2sgyt83LiY=";
  };

  preConfigure = ''
    export ARKOUDA_ZMQ_PATH=${zeromq}
    export ARKOUDA_HDF5_PATH=${hdf5.dev}
    export ARKOUDA_ARROW_PATH=${arrow-cpp}
    # need to work out iconv stuff. why libiconvReal?
    #export ARKOUDA_ICONV_PATH=${iconv}
    export ARKOUDA_IDN2_PATH=${libidn2}
    export ARKOUDA_SKIP_CHECK_DEPS=yes
    export LD_LIBRARY_PATH=${lib.makeLibraryPath [ glibc libiconv ]}

    echo "ZMQ_PATH=${zeromq}" >> Makefile.paths
    echo "HDF5_PATH=${hdf5.dev}" >> Makefile.paths
    echo "ARROW_PATH=${arrow-cpp}" >> Makefile.paths
    #echo "ICONV_PATH=${libiconv}" >> Makefile.paths
    echo "IDN2_PATH=${libidn2}" >> Makefile.paths
    cat Makefile.paths

    substituteInPlace Makefile \
      --replace "Checking for ZMQ" "Checking for ZMQ: \$(CHPL_FLAGS)"
    # looks like a bug with upstream
    substituteInPlace tests/server/TestBase.chpl \
      --replace "SymArrayDmap" "SymArrayDmapCompat"
  '';

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ chapel zeromq hdf5.dev arrow-cpp libiconv libidn2 curl libiconvReal ];

  propagatedBuildInputs = [ gmp ];

  enableParallelBuilding = true;

  doCheck = true;

  checkPhase = ''
    make test-bin
  '';

  installPhase = ''
    mkdir $out
    mkdir $out/bin
    cp arkouda_server $out/bin
  '';

  meta = with lib; {
    changelog = "https://github.com/Bears-R-Us/arkouda/releases/tag/v${version}";
    description = "Interactive Data Analytics at Supercomputing Scale";
    homepage = "https://bears-r-us.github.io/arkouda/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ nviets ];
  };
}
