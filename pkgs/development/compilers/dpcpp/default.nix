{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, ninja
, python3
}:

stdenv.mkDerivation rec {
  pname = "dpcpp";
  version = "20230406";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    #rev = "refs/tags/sycl-nightly/${version}";
    #rev = "5f036799f4d39c1aa5a6fac0e972050373e9fa78";
    rev = "cb91c232c661829b327c7e6e8232eb1d79100a98";
    hash = "sha256-abR9JhWCvwa+X/0y5mCGUsa+/3MUponHkjMO/XdYN8s=";
    deepClone = true;
  };

  patchPhase = ''
    ls
  '';

  configurePhase = ''
    ls llvm
    python llvm/buildbot/configure.py
    #python src/llvm/buildbot/compile.py
  '';

  nativeBuildInputs = [
    cmake
    #ninja
    python3
  ];

  #NIX_CFLAGS_COMPILE = [ "-DSYCL_USE_LIBCXX=ON" ];
  # Fix build with modern gcc
  # In member function 'void std::__atomic_base<_IntTp>::store(__int_type, std::memory_order) [with _ITp = bool]',
  #NIX_CFLAGS_COMPILE = lib.optionals stdenv.cc.isGNU [ "-Wno-error=stringop-overflow" ] ++
    # Workaround for gcc-12 ICE when using -O3
    # https://gcc.gnu.org/PR108854
    #lib.optionals (stdenv.cc.isGNU && stdenv.isx86_32) [ "-O2" ];

  meta = with lib; {
    description = "Intel Thread Building Blocks C++ Library";
    homepage = "http://threadingbuildingblocks.org/";
    license = licenses.asl20;
    longDescription = ''
      Intel Threading Building Blocks offers a rich and complete approach to
      expressing parallelism in a C++ program. It is a library that helps you
      take advantage of multi-core processor performance without having to be a
      threading expert. Intel TBB is not just a threads-replacement library. It
      represents a higher-level, task-based parallelism that abstracts platform
      details and threading mechanisms for scalability and performance.
    '';
    platforms = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice tmarkus ];
  };
}
