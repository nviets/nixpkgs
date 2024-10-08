{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pyyaml,
  jinja2,
}:

buildPythonPackage rec {
  pname = "hiyapyco";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zerwes";
    repo = pname;
    rev = "refs/tags/release-${version}";
    hash = "sha256-KB/KFrR7IScIWyYbsU+4BbV0+SCeeWxYDD8lbxosRLc=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    pyyaml
    jinja2
  ];

  checkPhase = ''
    runHook preCheck

    set -e
    find test -name 'test_*.py' -exec python {} \;

    runHook postCheck
  '';

  pythonImportsCheck = [ "hiyapyco" ];

  meta = with lib; {
    description = "Python library allowing hierarchical overlay of config files in YAML syntax";
    homepage = "https://github.com/zerwes/hiyapyco";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ veehaitch ];
  };
}
