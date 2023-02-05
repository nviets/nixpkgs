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
, humanfriendly
, compress-pickle
, pomegranate
, jupyter-events
}:

python3.pkgs.buildPythonPackage rec {
  pname = "sdgym";
  version = "0.6.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "sdv-dev";
    repo = "SDGym";
    rev = "v${version}";
    hash = "sha256-UoavpRY2v+S5OlhkQ/7wIla/1NHHe4Fg+Cv9XuJSi08=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'tabulate>=0.8.3,<0.9' 'tabulate>=0.8.3' \
      --replace 'humanfriendly>=8.2,<11' 'humanfriendly>=8.2' \
      --replace 'compress-pickle>=1.2.0,<3' 'compress-pickle>=1.2.0'
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
    humanfriendly
    compress-pickle
    pomegranate
    jupyter-events
  ];

  # Otherwise tests will fail to create directory
  # Permission denied: '/homeless-shelter'
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "sdgym" ];

  meta = with lib; {
    description = "Benchmarking synthetic data generation methods";
    homepage = "git@github.com:sdv-dev/SDGym.git";
    license = licenses.bsl11;
    maintainers = with maintainers; [ nviets ];
  };
}
