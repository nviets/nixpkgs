{ lib
, python3
, fetchFromGitHub
, numpy
, pandas
, matplotlib
, scipy
, rundoc
, pytest
, pytest-cov
, pytest-runner
, pytest-rerunfailures
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
    rundoc
    pytest
    pytest-cov
    pytest-runner
    pytest-rerunfailures
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'pytest-rerunfailures>=9.0.0,<10' 'pytest-rerunfailures>=9.0.0' \
      --replace 'pytest-cov>=2.6.0,<3' 'pytest-cov>=2.6.0' \
      --replace 'pytest>=6.2.5,<7' 'pytest>=6.2.5'
  '';

  checkInputs = [ pytest ];

  checkPhase = ''
    pytest tests/ --ignore=tests/end-to-end/test_visualization.py;
  '';

  pythonImportsCheck = [ "copulas" ];

  meta = with lib; {
    description = "A library to model multivariate data using copulas";
    homepage = "git@github.com:sdv-dev/Copulas.git";
    license = with licenses; [ bsl11 ];
    maintainers = with maintainers; [ nviets ];
  };
}
