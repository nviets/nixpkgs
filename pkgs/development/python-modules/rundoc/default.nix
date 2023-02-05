{ lib
, python3
, fetchFromGitHub
, argcomplete
, markdown
, beautifulsoup4
, pygments
, click
, markdown-rundoc
, prompt_toolkit
, pytest
, jupyter
}:

python3.pkgs.buildPythonPackage rec {
  pname = "rundoc";
  version = "0.4.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "eclecticiq";
    repo = "rundoc";
    rev = "${version}";
    #hash = "sha256-InXao+NaOqGHAUoOUP6TNCuSl30zqTsGJ8Rt4dO+cuI=";
    hash = "sha256-a/dKTXMiOQ6x5OsJ+MdYheyXsQIC1BY4vBtobR9y7bE=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'markdown>=2.6.9,<3.0' 'markdown>=2.6.9' \
      --replace 'click>=6.7,<8.0' 'click>=6.7' \
      --replace 'prompt_toolkit>=2.0,<3.0' 'prompt_toolkit>=2.0'
  '';

  propagatedBuildInputs = [
    argcomplete
    markdown
    beautifulsoup4
    pygments
    click
    markdown-rundoc
    prompt_toolkit
  ];

  nativeCheckInputs = [
    pytest
    jupyter
  ];

  pythonImportsCheck = [ "rundoc" ];

  meta = with lib; {
    description = "A command-line utility that runs code blocks from documentation";
    homepage = "git@github.com:eclecticiq/rundoc.git";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
