{ lib, stdenv, fetchFromGitHub, writeText, cmake, ninja, cudaPackages
, boost, glew, imgui, glfw3, gtest, libGL, autoPatchelfHook, addOpenGLRunpath
, cereal, zlib, openssl, cli11}:

stdenv.mkDerivation rec {
  pname = "alien";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "chrxh";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-cKg+X5/TTiq+s/aKbXbeqlauYD+o5SQF2q18HyHw96w=";
  };

  # Manually simulate a vcpkg installation so that it can link the libraries
  # properly. Follows: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/misc/trenchbroom/default.nix
  postUnpack =
    let
      vcpkg_target = "x64-linux";

      vcpkg_pkgs = [
        "boost"
        #"OpenGL"
        "glew"
        "imgui"
        #"implot"
        "glfw3"
        #"glad"
        "gtest"
        "zlib"
        "openssl"
        "cli11"
      ];

      updates_vcpkg_file = writeText "update_vcpkg_alien" (
        lib.concatMapStringsSep "\n" (name: ''
          Package : ${name}
          Architecture : ${vcpkg_target}
          Version : 1.0
          Status : is installed
        '') vcpkg_pkgs);
    in ''
      export VCPKG_ROOT="$TMP/vcpkg"

      mkdir -p $VCPKG_ROOT/.vcpkg-root
      mkdir -p $VCPKG_ROOT/installed/${vcpkg_target}/lib
      mkdir -p $VCPKG_ROOT/installed/vcpkg/updates
      ln -s ${updates_vcpkg_file} $VCPKG_ROOT/installed/vcpkg/status
      mkdir -p $VCPKG_ROOT/installed/vcpkg/info
      ${lib.concatMapStrings (name: ''
        touch $VCPKG_ROOT/installed/vcpkg/info/${name}_1.0_${vcpkg_target}.list
      '') vcpkg_pkgs}

      ln -s ${boost}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      #ln -s $OpenGL}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${glew.out}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${imgui}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      #ln -s $implot}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${glfw3}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      #ln -s $glad}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${gtest}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      ln -s ${zlib}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      #ln -s ${openssl}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      #ln -s ${cli11}/lib/lib* $VCPKG_ROOT/installed/${vcpkg_target}/lib/
      echo SUCCESS
    '';

  preConfigure = ''
    echo CONFIGUREPHASE
    #export CUDA_PATH="${cudaPackages.cudatoolkit}"
    export imgui_DIR=${imgui}
    substituteInPlace CMakeLists.txt \
      --replace "find_package(OpenGL REQUIRED)" "#find_package(OpenGL REQUIRED)" \
      --replace "find_package(imgui REQUIRED)" "#find_package(imgui REQUIRED)"
    cat external/vcpkg/scripts/buildsystems/vcpkg.cmake
  '';

  nativeBuildInputs = [ cmake ninja addOpenGLRunpath autoPatchelfHook ];

  buildInputs = [
    cudaPackages.cudatoolkit
    #cudaPackages.autoAddOpenGLRunpathHook
    addOpenGLRunpath
    autoPatchelfHook
    glew
    cereal
    imgui
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_MAKE_PROGRAM=ninja"
    "-DBoost_INCLUDE_DIR=${lib.getDev boost}/include"
    #"-DCMAKE_TOOLCHAIN_FILE=vcpkg/scripts/buildsystems/vcpkg.cmake"
    "-DVCPKG_MANIFEST_INSTALL=OFF"
    "-DCMAKE_CUDA_COMPILER=${cudaPackages.cudatoolkit}/bin/nvcc"
    "-DCMAKE_PREFIX_PATH=${imgui}"
  ];

  meta = with lib; {
    homepage = "https://alien-project.org/";
    description = "ALIEN  is an artificial life simulation program";
    license = licenses.bsd3;
    #platforms = platforms.unix;
    maintainers = with maintainers; [ nviets ];
  };
}
