{ config
, lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, pkg-config
#, git
, ninja
, python3
, python3Packages
, ocaml
, zlib
, libxml2
, libedit
, xar
#, cudaSupport ? config.cudaSupport or true
, cudaPackages
, spirv-tools
#, rocm-core
}:
let
  vc-intrinsics = fetchFromGitHub {
    owner = "intel";
    repo = "vc-intrinsics";
    #rev = "3ac855c9253d608a36d10b8ff87e62aa413bbf23";
    #hash = "sha256-i5A8R/EMXbjvghq+JRITDJi+FVH+lSy07qstNF2LVUc=";
    rev = "v0.3.0";
    hash = "sha256-1Rm4TCERTOcPGWJF+yNoKeB9x3jfqnh7Vlv+0Xpmjbk=";
  };
  ocl-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-Headers";
    rev = "v2023.02.06";
    hash = "sha256-BJDaDokyHgmyl+bGqCwG1J7iOvu0E3P3iYZ1/krot8s=";
  };
  ocl-loader = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "OpenCL-ICD-Loader";
    rev = "v2023.02.06";
    hash = "sha256-uWPwGznfqH0xvrpnVNdDn3H3tnAfJt9A3m6av0xlq7I=";
  };
  spirv-headers = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    #rev = "1feaf4414eb2b353764d01d88f8aa4bcc67b60db";
    #hash = "sha256-VOq3r6ZcbDGGxjqC4IoPMGC5n1APUPUAs9xcRzxdyfk=";
    rev = "sdk-1.3.243.0";
    hash = "sha256-VOq3r6ZcbDGGxjqC4IoPMGC5n1APUPUAs9xcRzxdyfk=";
  };
#  spirv-tools = fetchFromGitHub {
#    owner = "KhronosGroup";
#    repo = "SPIRV-Tools";
#    rev = "v2023.2";
#    hash = "sha256-aOq3r6ZcbDGGxjqC4IoPMGC5n1APUPUAs9xcRzxdyfk=";
#  };
  mp11 = fetchFromGitHub {
    owner = "boostorg";
    repo = "mp11";
    rev = "boost-1.81.0";
    hash = "sha256-rPr7uVGAc4x8vwbx/LhhWH6pcH2t9mS2q9WVL8vpTwQ=";
  };
  level-zero = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "level-zero";
    #rev = "v1.8.8";
    #hash = "sha256-hfbTgEbvrhWkZEi8Km7KaxJBAc9X1kA/T2DLooKa7KQ=";
    rev = "v1.9.9";
    hash = "sha256-zzlecBk7Mi3Nhj4eIAp81pq7+lIiKpvEaNeXuJKDPII=";
  };
  unified-runtime = fetchFromGitHub {
    owner = "oneapi-src";
    repo = "unified-runtime";
    #rev = "d6af758779db6eebdc419fd5e249302f566eb5de";
    #hash = "sha256-9ZIUZ2ZqEv9bcJKlItfXlfMdD968UCGIDLUTL3PmU3o=";
    rev = "v0.6";
    hash = "sha256-uu1Dw1y4C7tIuUph/uNwp+DwwubDgTEkFD1g32Cm/2I==";
  };
in
stdenv.mkDerivation rec {
  pname = "dpcpp";
  version = "20230406";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "llvm";
    rev = "cb91c232c661829b327c7e6e8232eb1d79100a98";
    hash = "sha256-gilApWrqIqKkqLDCpS7FHdWkT0j8LjCZpiQmqQjuos0=";
    #rev = "75b3cdb36cbee28bfd8242fc63a5c97dd7944a89";
    #hash = "sha256-26LqjRzKnRHm8/EMah6Y3NZXhBaSIhs/d+ya0rI7OOY=";
    deepClone = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
#    git
    ninja
    python3
    python3Packages.pygments
    python3Packages.pyyaml
    ocaml
    zlib
    libxml2
    libedit
    xar
    cudaPackages.cudatoolkit
    spirv-tools
#    rocm-core
  ]; #++ lib.optionals cudaSupport [ cudaPackages ];

  configurePhase = ''
    export CUDA_LIB_PATH=${cudaPackages.cudatoolkit}/lib64/stubs 
    export CC=${cudaPackages.cudatoolkit.cc}/bin/gcc
    export CXX=${cudaPackages.cudatoolkit.cc}/bin/g++
#    export SYCL_BUILD_PI_HIP_ROCM_DIR={rocm-core}
    python buildbot/configure.py \
      --l0-headers ${level-zero}/include \
      --l0-loader ${level-zero} \
      --enable-all-llvm-targets \
      --shared-libs \
      --cmake-opt="-DLLVMGenXIntrinsics_SOURCE_DIR=${vc-intrinsics}" \
      --cmake-opt="-DOpenCL_HEADERS=${ocl-headers}" \
      --cmake-opt="-DOpenCL_LIBRARY_SRC=${ocl-loader}" \
      --cmake-opt="-DBOOST_MP11_SOURCE_DIR=${mp11}" \
      --cmake-opt="-DLLVM_EXTERNAL_SPIRV_HEADERS_SOURCE_DIR=${spirv-headers}" \
      --cmake-opt="-DUNIFIED_RUNTIME_LIBRARY=${unified-runtime}" \
      --cmake-opt="-DUNIFIED_RUNTIME_INCLUDE_DIR=${unified-runtime}/include" \
      --cmake-opt="-DLLVM_OCAML_OUT_OF_TREE=TRUE" \
      --cmake-opt="-DLLVM_OCAML_INSTALL_PATH=${ocaml}" \
      --cuda \
      --cmake-opt="-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cudatoolkit}"
#      --hip \
#      --hip-platform "NVIDIA" \
#      --cmake-opt="DSYCL_BUILD_PI_HIP_ROCM_DIR={rocm-core}"
  '';

  buildPhase = ''
    export CUDA_LIB_PATH=${cudaPackages.cudatoolkit}/lib64/stubs 
    export CC=${cudaPackages.cudatoolkit.cc}/bin/gcc
    export CXX=${cudaPackages.cudatoolkit.cc}/bin/g++
    python buildbot/compile.py
    llvm/build/bin/clang++ -std=c++17 -O3 -fsycl -fsycl-targets=nvptx64-nvidia-cuda --cuda-path=${cudaPackages.cudatoolkit} *.cpp -o a.out
  '';

  installPhase = ''
    mkdir $out
    cp -r * $out
  '';

  #NIX_CFLAGS_COMPILE = [ "-DSYCL_USE_LIBCXX=ON" "-DLLVMGenXIntrinsics_SOURCE_DIR=${vc-intrinsics}" ];
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
