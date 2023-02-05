{ lib
, python3
, fetchFromGitHub
, numpy
, pandas
, faker
, scipy
, psutil
, scikit-learn
, rundoc
, jupyter
, copulas
}:

python3.pkgs.buildPythonPackage rec {
  pname = "rdt";
  version = "1.3.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdv-dev";
    repo = "RDT";
    rev = "v${version}";
    hash = "sha256-WrexSfVxRE4FA0tWgyXr4adNOg1mnh3VzrF7Q0zt8tY=";
  };

  nativeBuildInputs = [
    rundoc
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    faker
    scipy
    psutil
    scikit-learn
    jupyter
    copulas
  ];

  # RDT's unit tests are intermingled with paid addons that 
  # cause tests to fail. See:
  # - https://docs.sdv.dev/rdt/transformers-glossary/premium-add-ons
  doCheck = false;

  pythonImportsCheck = [ "rdt" ];

  meta = with lib; {
    description = "A library of Reversible Data Transforms";
    homepage = "git@github.com:sdv-dev/RDT.git";
    license = with licenses; [ bsl11 ];
    maintainers = with maintainers; [ nviets ];
  };
}
