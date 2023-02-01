{ lib
, python3
, fetchFromGitHub
, scikit-learn
, torch
, pandas
, rdt
, packaging
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

  propagatedBuildInputs = [
    scikit-learn
    torch
    pandas
    rdt
    packaging
  ];

  pythonImportsCheck = [ "ctgan" ];

  meta = with lib; {
    description = "Conditional GAN for generating synthetic tabular data";
    homepage = "git@github.com:sdv-dev/CTGAN.git";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
