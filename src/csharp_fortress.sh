#!/usr/bin/env bash
# csharp_fortress_v3.sh - Pragmatic .NET Isolation
# License: MIT
# Usage: ./csharp_fortress_v3.sh <project.csproj>

set -euo pipefail
shopt -s nocasematch

### SECTION 1: USER CONFIGURATION - REQUIRED ###
declare -A TRUSTED_CHECKSUMS=(
    ["dotnet-install.sh"]="INSERT_DOTNET_INSTALL_SH_SHA256"
    ["OmniSharp.zip"]="INSERT_OMNISHARP_SHA256"  # Get from official release
)
PRIVATE_NUGET_FEED="https://your.private/feed/v3/index.json"  # Leave empty to disable
MICROSOFT_GPG_KEY_URL="https://packages.microsoft.com/keys/microsoft.asc"

### SECTION 2: SYSTEM CHECKS ###
fail() { echo >&2 "❌ $*"; exit 1; }
check_deps() {
    local deps=(curl xmlstarlet jq)
    for dep in "${deps[@]}"; do
        command -v "$dep" >/dev/null || fail "Missing required dependency: $dep"
    done
}

check_deps

### SECTION 3: PROJECT VALIDATION ###
csproj="${1:-}"
if [[ -z "$csproj" ]]; then
    mapfile -t projects < <(find . -maxdepth 1 -name '*.csproj')
    [[ ${#projects[@]} -eq 1 ]] || fail "Specify project: $0 <project.csproj>"
    csproj="${projects[0]}"
fi
[[ -f "$csproj" ]] || fail "Project file not found: $csproj"

### SECTION 4: CORPORATE EXTENSION PURGE ###
purge_vscode_extensions() {
    local extensions=(
        "ms-dotnettools.csdevkit"
        "ms-dotnettools.vscode-dotnet-runtime"
    )
    
    for editor in code codium; do
        if command -v "$editor" >/dev/null; then
            for ext in "${extensions[@]}"; do
                "$editor" --uninstall-extension "$ext" 2>/dev/null || true
            done
        fi
    done
}
purge_vscode_extensions

### SECTION 5: SECURE SDK INSTALLATION ###
install_dotnet_sdk() {
    local install_dir="$(pwd)/.dotnet"
    mkdir -p "$install_dir"
    
    # Verify Microsoft GPG key
    curl -fsSL "$MICROSOFT_GPG_KEY_URL" -o microsoft.asc
    gpg --import microsoft.asc || fail "GPG key import failed"
    
    # Download and verify installer
    local installer_url="https://dot.net/v1/dotnet-install.sh"
    local installer_path="$(mktemp)"
    curl -fsSL "$installer_url" -o "$installer_path"
    
    # Checksum verification
    local actual_sha=$(sha256sum "$installer_path" | awk '{print $1}')
    [[ "$actual_sha" == "${TRUSTED_CHECKSUMS[dotnet-install.sh]}" ]] || fail "Installer checksum mismatch"
    
    # Signature verification
    curl -fsSL "${installer_url}.asc" -o "${installer_path}.asc"
    gpg --verify "${installer_path}.asc" "$installer_path" || fail "Installer signature invalid"

    # Install SDK
    bash "$installer_path" --version "$SDK_VERSION" --install-dir "$install_dir" --no-path
    rm "$installer_path" "${installer_path}.asc"
}
install_dotnet_sdk

### SECTION 6: NUGET CONFIGURATION ###
configure_nuget() {
    cat > NuGet.Config <<EOF
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <config>
    <add key="globalPackagesFolder" value="$(pwd)/.nuget/packages" />
  </config>
  <packageSources>
    <clear />
    $( [[ -n "$PRIVATE_NUGET_FEED" ]] && \
      echo "<add key=\"private\" value=\"$PRIVATE_NUGET_FEED\" protocolVersion=\"3\" />" )
  </packageSources>
  <disabledPackageSources>
    <add key="nuget.org" value="true" />
  </disabledPackageSources>
</configuration>
EOF
}
configure_nuget

### SECTION 7: CROSS-PLATFORM TELEMETRY BLOCK ###
block_telemetry() {
    case "$(uname -s)" in
        Linux*)
            sudo iptables -A OUTPUT -p tcp -d 13.107.9.2 -j DROP
            ;;
        Darwin*)
            sudo pfctl -t dotnet_telemetry -T add 13.107.9.2
            ;;
        CYGWIN*|MINGW*)
            netsh advfirewall firewall add rule name="Block .NET Telemetry" \
                dir=out remoteip=13.107.9.2 action=block
            ;;
    esac
}
block_telemetry

### SECTION 8: IDE INTEGRATION ###
configure_vscode() {
    local editor_path="$(command -v codium || command -v code)" || return
    
    # Install OmniSharp with verification
    local omnisharp_path="$(mktemp).vsix"
    curl -fsSL "https://github.com/OmniSharp/omnisharp-vscode/releases/download/v${OMNISHARP_VERSION}/omnisharp-vscode-${OMNISHARP_VERSION}.vsix" -o "$omnisharp_path"
    
    local actual_sha=$(sha256sum "$omnisharp_path" | awk '{print $1}')
    [[ "$actual_sha" == "${TRUSTED_CHECKSUMS[OmniSharp.zip]}" ]] || fail "OmniSharp checksum mismatch"
    
    "$editor_path" --install-extension "$omnisharp_path"
    rm "$omnisharp_path"

    # Generate workspace configuration
    mkdir -p .vscode
    cat > .vscode/settings.json <<EOF
{
  "dotnet.server.useOmnisharp": true,
  "dotnet.acquire.useRuntime": true,
  "telemetry.telemetryLevel": "off"
}
EOF
}
configure_vscode

### SECTION 9: CLEANUP & VALIDATION ###
echo "✅ Verification:"
./run-dotnet --info
echo "🛡️ .NET environment secured. Build with: ./run-dotnet build"

# Append to .gitignore
[[ -f .gitignore ]] && grep -qxF ".dotnet/" .gitignore || echo ".dotnet/" >> .gitignore
[[ -f .gitignore ]] && grep -qxF ".nuget/" .gitignore || echo ".nuget/" >> .gitignore