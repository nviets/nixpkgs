{
  lib,
  rustPlatform,
  fetchFromGitHub,
  protobuf,
  python3,
  rust-jemalloc-sys-unprefixed,
  rustc,
  makeWrapper,
  nix-update-script,
}:
rustPlatform.buildRustPackage {
  pname = "influxdb3";
  version = "3.0.3";
  src = fetchFromGitHub {
    owner = "influxdata";
    repo = "influxdb";
    rev = "384c457ef5f0d5ca4981b22855e411d8cac2688e";
    hash = "sha256-xCvm0PSQmi0nVpgh/dRrIeZAQUvrQtTrNIqLKWO3Sk4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-0FQ6tNa8qNSyA0YCPZSnSip0Pl65yKRbek3J/e/DP6g=";

  nativeBuildInputs = [
    makeWrapper
    protobuf
    rustc.llvmPackages.lld
  ];

  buildInputs = [
    rust-jemalloc-sys-unprefixed
    python3
  ];

  env = {
    GIT_HASH = "000000000000000000000000000000000000000000000000000";
    GIT_HASH_SHORT = "0000000";
    PYO3_PYTHON = lib.getExe python3;
  };

  postPatch = ''
    # We provide GIT_HASH and GIT_HASH_SHORT ourselves
    rm influxdb3_process/build.rs
  '';

  buildNoDefaultFeatures = true;
  buildFeatures = [
    "aws"
    "gcp"
    "azure"
    "jemalloc_replacing_malloc"
    #"system-py"
  ];

  postInstall = ''
    wrapProgram $out/bin/influxdb3 \
      --set PYTHONHOME ${python3} \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          rust-jemalloc-sys-unprefixed
          python3
        ]
      }
  '';

  # Tests require running instance
  doCheck = false;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "v(3.*)"
    ];
  };

  meta = {
    description = "Scalable datastore for metrics, events, and real-time analytics";
    homepage = "https://github.com/influxdata/influxdb";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ oddlama ];
    mainProgram = "influxdb3";
  };
}
