{ lib, stdenv, fetchurl, unzip }:

{ pname
, version
, owner
, repo
, tag ? "v${version}"
, sources
, appName
, description
, homepage ? "https://github.com/${owner}/${repo}"
, license ? lib.licenses.unfree
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

  dontUnpack = true;
  dontStrip = true;
  nativeBuildInputs = lib.optionals isZip [ unzip ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications $out/bin unpacked
    ${if isZip then "unzip -q $src -d unpacked" else "tar -xzf $src -C unpacked"}
    app=$(find unpacked -maxdepth 3 -name '${appName}.app' -type d | head -n1)
    if [ -z "$app" ]; then
      echo "Could not find ${appName}.app" >&2
      find unpacked -maxdepth 3 >&2
      exit 1
    fi
    cp -R "$app" $out/Applications/
    makeWrapper=$out/bin/${pname}
    cat > "$makeWrapper" <<EOF
#!/bin/sh
exec open "$out/Applications/${appName}.app" --args "\$@"
EOF
    chmod +x "$makeWrapper"
    runHook postInstall
  '';

  meta = {
    inherit description homepage license;
    platforms = builtins.attrNames sources;
    mainProgram = pname;
  };
}
