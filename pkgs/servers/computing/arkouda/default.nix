{ lib, stdenv, fetchFromGitHub, pkg-config
, chapel, zeromq, hdf5, arrow-cpp, iconv, libiconv, glibc, libidn2, gmp}:

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

  #outputs = [ "out" ];

  nativeBuildInputs = [ pkg-config ];

  preConfigure = ''
    export ARKOUDA_ZMQ_PATH=${zeromq}
    export ARKOUDA_HDF5_PATH=${hdf5.dev}
    export ARKOUDA_ARROW_PATH=${arrow-cpp}
    export ARKOUDA_ICONV_PATH=${libiconv}
    export ARKOUDA_IDN2_PATH=${libidn2}
    export ARKOUDA_SKIP_CHECK_DEPS=yes
  '';

  cmakeFlags = [
    "-DARKOUDA_ZMQ_PATH=${zeromq}"
    "-DARKOUDA_HDF5_PATH=${hdf5.dev}"
    "-DARKOUDA_ARROW_PATH=${arrow-cpp}"
    "-DARKOUDA_ICONV_PATH=${libiconv}"
    "-DARKOUDA_IDN2_PATH=${libidn2}"
  ];

  buildInputs = [ chapel zeromq hdf5.dev arrow-cpp iconv libiconv glibc libidn2 ];

  propagatedBuildInputs = [ gmp ];

  meta = with lib; {
    changelog = "https://github.com/Bears-R-Us/arkouda/releases/tag/v${version}";
    description = "Interactive Data Analytics at Supercomputing Scale";
    homepage = "https://bears-r-us.github.io/arkouda/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ nviets ];
  };
}
