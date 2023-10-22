{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools-scm

# dependencies
, setuptools
, numpy
, pandas
, pyzmq
, typeguard
, tabulate
, pyfiglet
, versioneer
, matplotlib
, h5py
, types-tabulate
, tables
, pyarrow

# tests
, pytest
, pytest-env
, arkouda_server
 }:

buildPythonPackage rec {
  pname = "arkouda";
  version = "2023.10.06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Bears-R-Us";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-4ckae0X+pjP30/B7r9l1eW+iaxi2BPqyj2sgyt83LiY=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    setuptools
    numpy
    pandas
    pyzmq
    typeguard
    tabulate
    pyfiglet
    versioneer
    matplotlib
    h5py
    types-tabulate
    tables
    pyarrow
  ];

  nativeCheckInputs = [
    pytest
    pytest-env
    arkouda_server
  ];

  doCheck = true;

  checkPhase = ''
    export ARKOUDA_HOME=${arkouda_server}/bin
    make test
  '';

  pythonImportsCheck = [ "arkouda" ];

  meta = with lib; {
    changelog = "https://github.com/Bears-R-Us/arkouda/releases/tag/v${version}";
    description = "Interactive Data Analytics at Supercomputing Scale";
    homepage = "https://bears-r-us.github.io/arkouda/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ nviets ];
  };
}
