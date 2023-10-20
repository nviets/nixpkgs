{ lib, stdenv, fetchFromGitHub, pkg-config, chapel}:

stdenv.mkDerivation rec {
  pname = "arkouda";
  version = "2023.10.06";

  src = fetchFromGitHub {
    owner = "Bears-R-Us";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-4ckae0X+pjP30/B7r9l1eW+iaxi2BPqyj2sgyt83LiY=";
  };

  #outputs = [ "out" ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ chapel ];

  meta = with lib; {
    changelog = "https://github.com/Bears-R-Us/arkouda/releases/tag/v${version}";
    description = "Interactive Data Analytics at Supercomputing Scale";
    homepage = "https://bears-r-us.github.io/arkouda/index.html";
    license = licenses.mit;
    maintainers = with maintainers; [ nviets ];
  };
}
