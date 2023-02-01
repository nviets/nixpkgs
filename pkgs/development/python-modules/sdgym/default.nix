{ lib
, python3
, fetchFromGitHub
, botocore
, rdt
, sdmetrics
, appdirs
, torch
, XlsxWriter
, boto3
, tabulate
, sdv
}:

python3.pkgs.buildPythonPackage rec {
  pname = "sdgym";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdv-dev";
    repo = "SDGym";
    rev = "v${version}";
    hash = "sha256-HlzWjBTrsDrh+/GTVqZD/bCae2BUyaV3NrX4qQXfL9k=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'prompt_toolkit>=2.0,<3.0' 'prompt_toolkit>=2.0' \
      --replace 'tabulate>=0.8.3,<0.9' 'tabulate>=0.8.3' \
      --replace 'humanfriendly>=8.2,<11' 'humanfriendly>=8.2' sdmetrics>=0.9.0,<1.0
      --replace 'sdmetrics>=0.9.0,<1.0' 'sdmetrics>=0.9.0'
  '';

  propagatedBuildInputs = [
    botocore
    rdt
    sdmetrics
    appdirs
    torch
    XlsxWriter
    boto3
    tabulate
    sdv
  ];

  pythonImportsCheck = [ "sdgym" ];

  meta = with lib; {
    description = "Benchmarking synthetic data generation methods";
    homepage = "git@github.com:sdv-dev/SDGym.git";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
