{ lib, stdenv, fetchFromGitHub, cmake }:


stdenv.mkDerivation rec {
  pname = "lantern";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "mlverse";
    repo = "torch";
    rev = "v${version}";
    sha256 = "sha256-y375pH8ILw3bE1kQN+y8UlAgeYwXO+8mGnhZ155Ikb8=";
    sparseCheckout = [ "src/lantern" ];
  };

  preConfigure = ''
    cd src/lantern
    substituteInPlace
  '';

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Lantern provides a C API to libtorch";
    homepage = "https://torch.mlverse.org/";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ nviets ];
  };
}
