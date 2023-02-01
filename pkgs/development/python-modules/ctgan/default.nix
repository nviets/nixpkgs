{ lib
, python3
, fetchFromGitHub
, scikit-learn
, torch
, pandas
, rdt
, packaging
, rundoc
, pytest
, pytest-cov
, pytest-rerunfailures
}:

python3.pkgs.buildPythonPackage rec {
  pname = "ctgan";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdv-dev";
    repo = "CTGAN";
    rev = "v${version}";
    hash = "sha256-iwEO04uxoP7Kx5GmXo0dKFjcYhyTwDiImrFL9+kOWrU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'pytest-rerunfailures>=9.1.1,<10' 'pytest-rerunfailures>=9.1.1'
  '';

  propagatedBuildInputs = [
    scikit-learn
    torch
    pandas
    rdt
    packaging
    rundoc
    pytest-cov
    pytest-rerunfailures
    pytest
  ];

  pythonImportsCheck = [ "ctgan" ];

  meta = with lib; {
    description = "Conditional GAN for generating synthetic tabular data";
    homepage = "git@github.com:sdv-dev/CTGAN.git";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
