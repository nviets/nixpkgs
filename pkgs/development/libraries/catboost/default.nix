{ config
, stdenv
, lib
, fetchFromGitHub
, python3
, R
, rPackages
#, cmake
#, gtest
#, doCheck ? true
#, cudaSupport ? config.cudaSupport or false
#, cudaPackages
#, llvmPackages
}:

stdenv.mkDerivation rec {
  pname = "catboost";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "catboost";
    repo = pname;
    rev = "refs/tags/v${version}";
    #fetchSubmodules = true;
    hash = "sha256-bqnUHTTRan/spA5y4LRt/sIUYpP3pxzdN/4wHjzgZVY=";
  };

  nativeBuildInputs = [ python3 R rPackages.devtools ];

  propagatedBuildInputs = [
    rPackages.jsonlite
  ];

  postPatch = ''
    substituteInPlace catboost/R-package/mk_package.py --replace ", '--build', "          ", '--build', '-l $out/library', "
    #substituteInPlace catboost/R-package/mk_package.py --replace ", '--install-tests', '--no-multiarch', '--with-keep.source'"          ""
    #substituteInPlace catboost/R-package/mk_package.py --replace ", self.r_dir, "          ", '-l $out/library', self.r_dir, "
  '';

  configurePhase = ''
    runHook preConfigure
    export R_LIBS_SITE="$R_LIBS_SITE''${R_LIBS_SITE:+:}$out/library"
    runHook postConfigure
  '';

  installPhase = ''
    export R_LIBS_SITE="$out/library:$R_LIBS_SITE''${R_LIBS_SITE:+:}"
    ls
    ls build
    cd catboost/R-package
    mkdir -p $out
    mkdir -p $out/library
    export R_LIBS_SITE="$R_LIBS_SITE''${R_LIBS_SITE:+:}$out/library"
    #R -e "devtools::build(); withr::with_libpaths('$out/library'); devtools::install()"
    python mk_package.py --build-with-r
    ls
  '';

  postFixup = ''
    if test -e $out/nix-support/propagated-build-inputs; then
        ln -s $out/nix-support/propagated-build-inputs $out/nix-support/propagated-user-env-packages
    fi
  '';

  meta = with lib; {
    description = "CatBoost is a machine learning method based on gradient boosting over decision trees.";
    homepage = "https://github.com/catboost/catboost";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ nviets ];
  };
}
