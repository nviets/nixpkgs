{ lib
, python3
, fetchFromGitHub
, tqdm
, pandas
, torch
, pytest-runner
}:

python3.pkgs.buildPythonPackage rec {
  pname = "deepecho";
  version = "0.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdv-dev";
    repo = "DeepEcho";
    rev = "v${version}";
    hash = "sha256-XoOtJV4ov56FASSItSd3WlmxpTVFfqKe8N3Po6vIiro=";
  };

  propagatedBuildInputs = [
    tqdm
    pandas
    torch
    pytest-runner
  ];

  doCheck = false;

  pythonImportsCheck = [ "deepecho" ];

  meta = with lib; {
    description = "Synthetic Data Generation for mixed-type, multivariate time series";
    homepage = "git@github.com:sdv-dev/DeepEcho.git";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
