{ buildGoModule
, fetchFromGitHub
, fetchurl
, fetchpatch
, go-bindata
, lib
, llvmPackages
, perl
, pkg-config
, rustPlatform
, stdenv
, libiconv
, protobuf
}:

rustPlatform.buildRustPackage {
    pname = "influxdb_iox";
    version = "dev";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "influxdb_iox";
      rev = "840923abab56f5f5f7fedf2a622e5f976a3d9eac";
      sha256 = "sha256-ZBxs0CuyoAQP5+yEjlLPziIc+u83i64Q/+RgSiU8eWc=";
    };
    #sourceRoot = "source/libflux";
    cargoSha256 = "sha256-RXAdTBtD0b/iEToJuefQFJSZAsTQ+TqODVFlA6VvuNk=";
    nativeBuildInputs = [ llvmPackages.libclang protobuf ];
    buildInputs = lib.optional stdenv.isDarwin libiconv;
    LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
    pkgcfg = ''
      Name: influxdb_iox
      Version: "dev"
      Description: Influx IOX
    '';
    passAsFile = [ "pkgcfg" ];
    postInstall = ''
      mkdir -p $out/include $out/pkgconfig
      cp -r $NIX_BUILD_TOP/source/libflux/include/influxdata $out/include
      substitute $pkgcfgPath $out/pkgconfig/flux.pc \
        --replace /out $out
    '' + lib.optionalString stdenv.isDarwin ''
      install_name_tool -id $out/lib/libflux.dylib $out/lib/libflux.dylib
    '';

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ nviets ];
  };
}
