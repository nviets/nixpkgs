{ lib
, python3
, fetchFromGitHub
, numpy
, pandas
, matplotlib
, scipy
}:

python3.pkgs.buildPythonPackage rec {
  pname = "copulas";
  version = "0.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdv-dev";
    repo = "Copulas";
    rev = "v${version}";
    hash = "sha256-Xei8ZrEKxq+wM+zW1c5WOTy8DQJPg2grBOvcUqNk1Zk=";
  };

  propagatedBuildInputs = [
    numpy
    pandas
    matplotlib
    scipy
  ];

  doCheck = false;

  pythonImportsCheck = [ "copulas" ];

  meta = with lib; {
    description = "A library to model multivariate data using copulas";
    homepage = "git@github.com:sdv-dev/Copulas.git";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
