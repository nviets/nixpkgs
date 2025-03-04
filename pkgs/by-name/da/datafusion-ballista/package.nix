{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
  protobuf
}:

rustPlatform.buildRustPackage rec {
  pname = "datafusion-ballista";
  version = "44.0.0-rc1";

  src = fetchFromGitHub {
    name = "datafusion-ballista-source";
    owner = "apache";
    repo = "datafusion-ballista";
    rev = version;
    sha256 = "sha256-+RBLK78pTDq9hilnoh1klxPcXTriiSUp3DunYCB3/yY=";
  };

  #sourceRoot = "${src.name}/datafusion-ballista";

  useFetchCargoVendor = true;
  cargoHash = "sha256-/zy1scQ/J2ye8SDsuzoNZ+2GzWNe2NDsmkwdkULqxXk=";

  PROTOC = "${protobuf}/bin/protoc";
  PROTOC_INCLUDE = "${protobuf}/include";

  buildInputs = [ protobuf ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  checkFlags = [
    # Some tests not found fake path
    #"--skip=catalog::tests::query_gs_location_test"
  ];

  meta = with lib; {
    description = "DataFusion Ballista";
    #mainProgram = "datafusion-ballista";
    homepage = "https://arrow.apache.org/datafusion";
    #changelog = "https://github.com/apache/arrow-datafusion/blob/${version}/datafusion/CHANGELOG.md";
    changelog = "https://github.com/apache/datafusion-ballista/blob/main/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ nviets ];
  };
}
