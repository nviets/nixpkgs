{ lib
, python3
, fetchFromGitHub
, tqdm
, rdt
, pandas
, deepecho
, sdmetrics
, ctgan
, graphviz
, cloudpickle
, faker
}:

python3.pkgs.buildPythonPackage rec {
  pname = "sdv";
  version = "0.18.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdv-dev";
    repo = "SDV";
    rev = "v${version}";
    hash = "sha256-chcJaJiCok9oxa1cAH8tnmn+sjNnpfOkTyfYvLugrlg=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'Faker>=10,<15' 'Faker>=10'
  '';

  propagatedBuildInputs = [
    pandas
    rdt
    sdmetrics
    ctgan
    graphviz
    deepecho
    cloudpickle
    faker
  ];

  doCheck = false;

  pythonImportsCheck = [ "sdv" ];

  meta = with lib; {
    description = "Synthetic Data Generation for tabular, relational and time series data";
    homepage = "git@github.com:sdv-dev/SDV.git";
    license = with licenses; [ ];
    maintainers = with maintainers; [ ];
  };
}
