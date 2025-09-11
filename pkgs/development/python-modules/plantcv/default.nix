{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  matplotlib,
  numpy,
  pandas,
  python-dateutil,
  scipy,
  scikit-image,
  scikit-learn,
  dask,
  dask-jobqueue,
  opencv-python,
  xarray,
  statsmodels,
  altair,
  vl-convert-python,

  # tests
  pytest,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "plantcv";
  version = "4.9";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-GrcMbMVRzDe+oSnRp1ebrU1bd70/oSZKRWNAabdGRcw=";
  };

  postPatch = ''
    # don't test bash builtins
    #rm testing/test_argcomplete.py
    substituteInPlace pyproject.toml \
      --replace '"nd2"' '#nd2'
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    matplotlib
    numpy
    pandas
    python-dateutil
    scipy
    scikit-image
    scikit-learn
    dask
    dask-jobqueue
    opencv-python
    xarray
    statsmodels
    altair
    vl-convert-python
  ];

  pythonRelaxDeps = [
    "scipy"
  ];

  nativeCheckInputs = [
    pytest
    pytest-cov
  ];

  meta = {
    changelog = "https://github.com/danforthcenter/plantcv/releases/tag/v${version}";
    description = "Plant phenotyping with image analysis";
    homepage = "https://plantcv.danforthcenter.org/";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [
      nviets
    ];
  };
}
