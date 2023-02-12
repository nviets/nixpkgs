{ config
, stdenv
, lib
, fetchFromGitHub
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

  nativeBuildInputs = [ R rPackages.devtools ];

  propagatedBuildInputs = [
    rPackages.jsonlite
  ];

  preBuild = ''
    cd catboost/R-package
  '';

  buildPhase = ''
    R -e "devtools::build(); devtools::install()"
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
