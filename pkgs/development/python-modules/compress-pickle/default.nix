{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonPackage rec {
  pname = "compress-pickle";
  version = "2.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "lucianopaz";
    repo = "compress_pickle";
    rev = "v${version}";
    hash = "sha256-C6KgAoa8q9uFpPxwYLqvZ6Z2li85Iya5NJ2ClsLe4R4=";
  };

  pythonImportsCheck = [ "compress_pickle" ];

  meta = with lib; {
    description = "Standard python pickle, thinly wrapped with standard compression libraries";
    homepage = "git@github.com:lucianopaz/compress_pickle.git";
    changelog = "https://github.com/lucianopaz/compress_pickle/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
