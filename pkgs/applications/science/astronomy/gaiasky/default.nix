{ stdenv, lib, fetchpatch, fetchgit, makeWrapper, writeText, runtimeShell, openjdk, perl, gradle_7, git, which }:

let
  pname = "gaiasky";
  version = "3.5.0-rc05";

  src_sha256 = "sha256-elG9gh8VdYiDM2AzkmM1hXAqjJBuA9LlSBPZGe7G9II=";
  deps_outputHash = "sha256-Qfig/kHl3YDniR/URBxDO7mfuIMiqiVw451EC+l+S5U=";

  jdk = openjdk;
  gradle = gradle_7;

  src = fetchgit {
    url = "https://codeberg.org/gaiasky/gaiasky.git";
    rev = "${version}";
    sha256 = src_sha256;
  };

  deps = stdenv.mkDerivation {
    name = "${pname}-deps";
    inherit src;

    nativeBuildInputs = [ jdk perl gradle git ];

    buildPhase = ''
      echo HELLOWORLD
      #GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk} --no-daemon jar
      GRADLE_USER_HOME=$PWD ./gaiasky
    '';

    # Mavenize dependency paths
    # e.g. org.codehaus.groovy/groovy/2.4.0/{hash}/groovy-2.4.0.jar -> org/codehaus/groovy/groovy/2.4.0/groovy-2.4.0.jar
    installPhase = ''
      find ./caches/modules-2 -type f -regex '.*\.\(jar\|pom\)' \
        | perl -pe 's#(.*/([^/]+)/([^/]+)/([^/]+)/[0-9a-f]{30,40}/([^/\s]+))$# ($x = $2) =~ tr|\.|/|; "install -Dm444 $1 \$out/$x/$3/$4/$5" #e' \
        | sh
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = deps_outputHash;
  };

  # Point to our local deps repo
  gradleInit = writeText "init.gradle" ''
    logger.lifecycle 'Replacing Maven repositories with ${deps}...'
    gradle.projectsLoaded {
      rootProject.allprojects {
        buildscript {
          repositories {
            clear()
            maven { url '${deps}' }
          }
        }
        repositories {
          clear()
          maven { url '${deps}' }
        }
      }
    }
    settingsEvaluated { settings ->
      settings.pluginManagement {
        repositories {
          maven { url '${deps}' }
        }
      }
    }
  '';

in stdenv.mkDerivation rec {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper jdk git gradle ];

  buildPhase = ''
    GRADLE_USER_HOME=$PWD gradle -Dorg.gradle.java.home=${jdk} --no-daemon --offline --init-script ${gradleInit} -x test build
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/share

    cp -a ./BIN/. $out/share/${pname}
    makeWrapper $out/share/${pname}/${pname}.sh $out/bin/${pname} \
      --set JAVA_HOME ${jdk} \
      --prefix PATH : ${lib.makeBinPath [ jdk which ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Open source 3D universe simulator for desktop and VR with support for more than a billion objects.";
    homepage = "https://zah.uni-heidelberg.de/gaia/outreach/gaiasky";
    license = licenses.mpl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nviets ];
  };
}
