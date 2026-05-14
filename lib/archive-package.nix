{ lib, stdenv, fetchurl, unzip, autoPatchelfHook ? null, makeWrapper ? null }:

{ pname
, version
, owner
, repo
, tag ? "v${version}"
, sources
, binaryName
, mainProgram ? binaryName
, description
, homepage ? "https://github.com/${owner}/${repo}"
, license ? lib.licenses.unfree
, extraInstall ? ""
, runtimeInputs ? [ ]
}:

let
  source = sources.${stdenv.hostPlatform.system} or (throw "${pname} is not supported on ${stdenv.hostPlatform.system}");
  isZip = lib.hasSuffix ".zip" source.asset;
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/${owner}/${repo}/releases/download/${tag}/${source.asset}";
    hash = source.hash;
  };

  nativeBuildInputs = lib.optionals isZip [ unzip ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ]
    ++ lib.optionals (runtimeInputs != [ ]) [ makeWrapper ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  dontStrip = stdenv.hostPlatform.isDarwin;

  unpackPhase = if isZip then ''
    runHook preUnpack
    unzip -q $src
    runHook postUnpack
  '' else ''
    runHook preUnpack
    tar -xf $src
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    candidate=$(find . -type f -name '${binaryName}' | head -n1)
    if [ -z "$candidate" ]; then
      echo "Could not find ${binaryName} in archive" >&2
      find . -maxdepth 3 -type f >&2
      exit 1
    fi
    install -m755 "$candidate" $out/bin/${mainProgram}
    ${lib.optionalString (runtimeInputs != [ ]) ''
      wrapProgram $out/bin/${mainProgram} --prefix PATH : ${lib.makeBinPath runtimeInputs}
    ''}
    ${extraInstall}
    runHook postInstall
  '';

  meta = {
    inherit description homepage license mainProgram;
    platforms = builtins.attrNames sources;
  };
}
