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
, lld
}:

rustPlatform.buildRustPackage {
    pname = "influxdb_iox";
    version = "dev";
    src = fetchFromGitHub {
      owner = "influxdata";
      repo = "influxdb_iox";
      rev = "55257b46c942df9daea41bfaf16830c3fa218158";
      sha256 = "sha256-Ss7MEtWHufkNZcB/z8Z4pv6AqZxj3aMOOLj3xEL8xVE=";
    };
    #sourceRoot = "source/influxdb_iox";
    cargoSha256 = "sha256-P2HYmr1rXSKbyP8S4UaN7ojiY5ojudf4tvYoTegU8NM=";
    nativeBuildInputs = [ llvmPackages.libclang protobuf lld ];
    buildInputs = [ llvmPackages.libclang protobuf lld ] ++ lib.optional stdenv.isDarwin libiconv;
    #LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
#    pkgcfg = ''
#      Name: influxdb_iox
#      Version: "dev"
#      Description: Influx IOX
#      Cflags: -I/out/include
#      Libs: -L/out/lib -ldl -lpthread
#    '';
    configurePhase = ''
      # https://github.com/NixOS/nixpkgs/blob/c3cc2bded1d080e20fa2b2b546bf04f19eef5cd9/pkgs/servers/mail/vsmtp/default.nix
      # see this page for an example of GIT_HASH patch
      cat influxdb_iox/build.rs
      export VERSION_HASH=55257b46c942df9daea41bfaf16830c3fa218158
      export RUST_BACKTRACE=1
    '';
#    passAsFile = [ "pkgcfg" ];
#    postInstall = ''
#      mkdir -p $out/include $out/pkgconfig
#      cp -r $NIX_BUILD_TOP/source/libflux/include/influxdata $out/include
#      substitute $pkgcfgPath $out/pkgconfig/flux.pc \
#        --replace /out $out
#    '' + lib.optionalString stdenv.isDarwin ''
#      install_name_tool -id $out/lib/libflux.dylib $out/lib/libflux.dylib
#    '';

  meta = with lib; {
    description = "An open-source distributed time series database";
    license = licenses.mit;
    homepage = "https://influxdata.com/";
    maintainers = with maintainers; [ nviets ];
  };
}
