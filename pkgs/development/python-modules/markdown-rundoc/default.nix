{ lib
, python3
, fetchFromGitLab
, markdown
}:

python3.pkgs.buildPythonPackage rec {
  pname = "markdown-rundoc";
  version = "0.3.1";
  format = "setuptools";

  src = fetchFromGitLab {
    owner = "nul.one";
    repo = "markdown-rundoc";
    rev = version;
    hash = "sha256-jk5KrWHSR0ggptxnh6heCxPGWXmTf4REA7MO0TLUYt4=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'markdown>=2.6.9,<3.0' 'markdown>=2.6.9'
  '';

  propagatedBuildInputs = [
    markdown
  ];

  #pythonImportsCheck = [ "markdown-rundoc" ];

  meta = with lib; {
    description = "Markdown extensions for rundoc";
    homepage = "git@github.com:eclecticiq/markdown-rundoc.git";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
