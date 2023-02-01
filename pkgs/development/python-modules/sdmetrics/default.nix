{ lib
, python3
, fetchFromGitHub
, pandas
, copulas
, plotly
, tqdm
, scikit-learn
}:

python3.pkgs.buildPythonPackage rec {
  pname = "sdmetrics";
  version = "0.9.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdv-dev";
    repo = "SDMetrics";
    rev = "v${version}";
    hash = "sha256-a63bck3NVmR+CpP0PwtJ9Xh93LGfEpMyIEdFsycQ/0Q=";
  };

  propagatedBuildInputs = [
    copulas
    pandas
    plotly
    tqdm
    scikit-learn
  ];

  doCheck = false;

  pythonImportsCheck = [ "sdmetrics" ];

  meta = with lib; {
    description = "Metrics to evaluate quality and efficacy of synthetic datasets";
    homepage = "git@github.com:sdv-dev/SDMetrics.git";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
