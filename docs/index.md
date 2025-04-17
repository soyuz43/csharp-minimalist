# 🛡️ C# Fortress: No-BS Documentation

---

## 🔥 **What This Script Actually Does**

### ✅ **The Good Stuff**
1. **Sandboxes .NET Like a Champ**  
   - Creates `.dotnet/` and `.nuget/packages/` in your project  
   - *Real Isolation*: Doesn't touch your system-wide .NET install  
   - Wrappers (`run-dotnet`) enforce local paths + kill telemetry  

2. **Supply Chain Paranoia Mode**  
   - Auto-fetches checksums from Microsoft's servers  
   - Verifies every download (SDK, VSIX) against these checksums  
   - *Not Trusting OpenVSX Blindly*: Validates OmniSharp extension SHA-256  

3. **Corporate Cancer Removal**  
   - Nukes MS Dev Kit extensions from orbit  
   - Installs clean OmniSharp from open-vsx.org  

4. **Linux Users Get Extra Love**  
   - Option to block telemetry IPs via `ufw`  
   - Actual command: `sudo ufw deny out to 13.107.9.2`  

---

## 💀 **Brutal Honesty Hour**

### ❌ **What It Doesn't Do**
1. **Full Telemetry Blocking is a Lie**  
   - Windows/macOS? You're still phoning home to Redmond  
   - `DOTNET_CLI_TELEMETRY_OPTOUT` is best-effort (Microsoft ignores it sometimes)  

2. **NuGet Config Will Break Your Build**  
   ```xml
   <packageSources><clear/></packageSources>
   ```  
   - Congrats! You now have **zero package sources**  
   - You'll manually edit `NuGet.Config` to add your private feeds  

3. **Windows Support is Half-Baked**  
   - Requires Chocolatey for `xmlstarlet` (fails on locked-down enterprise PCs)  
   - No firewall rules for Windows (because PowerShell is hard, right?)  

4. **False Sense of Security**  
   - Verifies installers but *not* subsequent NuGet packages  
   - `.dotnet/shared/` still uses global cache (potential DLL hijack)  

---

## 🧨 **When to Use This (And When to Run)**

### 👍 **Good For**
- Quick prototypes where you want **minimal corporate spyware**  
- Linux devs who want basic telemetry IP blocking  
- Teams who **already have private NuGet feeds**  

### ☠️ **Terrible For**
- Enterprise environments with mandatory VS Code extensions  
- Windows shops without Chocolatey access  
- Projects needing public NuGet packages (you'll edit configs anyway)  

---

## 🛠️ **Usage: What Actually Works**

### Basic Setup
```bash
# 1. Make it executable
chmod +x csharp_fortress_v2.sh

# 2. Run with your project
./csharp_fortress_v2.sh MyProject.csproj

# 3. Prepare for NuGet hell (edit NuGet.Config)
vim NuGet.Config  # Add your package sources!
```

### Telemetry Nuclear Option (Linux Only)
```bash
# Edit script header first!
TELEMETRY_BLOCK_NETWORK=true
./csharp_fortress_v2.sh MyProject.csproj  # Now with ufw rules!
```

---

## 💣 **Known Grenades**

| Issue | Workaround |
|-------|------------|
| **"Where's NuGet.org?!"** | Add `<add key="nuget.org" value="https://api.nuget.org/v3/index.json" />` to `NuGet.Config` |
| **Windows Firewall Gap** | Manually block in PowerShell: <br> `New-NetFirewallRule -DisplayName "Block .NET Spy" -RemoteAddress 13.107.9.2 -Direction Outbound -Action Block` |
| **Corporate VPN Breaks Checksums** | `curl` → corporate proxy hell. Good luck. |

---

## 🚑 **Emergency Exits**

### "This Broke My Machine!"
```bash
# Nuke the sandbox
rm -rf .dotnet .nuget run-dotnet*

# Undo Linux firewall rules
sudo ufw delete $(sudo ufw status numbered | grep 'Block .NET telemetry' | awk -F'[][]' '{print $2}')
```

### "I Need Microsoft's Spyware"
```bash
# Edit wrappers to remove telemetry opt-out
sed -i '/DOTNET_CLI_TELEMETRY_OPTOUT/d' run-dotnet
```

---

## 🔮 **If You Want Real Security**

1. **Network Monitoring**  
   ```bash
   mitmproxy --mode transparent --showhost
   ```
   - Actually see what .NET is phoning home about

2. **Hermetic Builds**  
   - Use Nix or Bazel to lock down every dependency

3. **Kernel-Level Blocking**  
   ```bash
   iptables -I OUTPUT -d 13.107.9.2 -j DROP
   ```
   - Works on any Linux, no `ufw` needed

4. **Compile Your Own .NET**  
   - Fork the runtime and rip out telemetry:  
     `git clone https://github.com/dotnet/runtime && s/Telemetry/\/\/Telemetry/g`

---

# 🎯 Bottom Line  
This script is a **duct-tape solution** for .NET isolation. It'll piss off your corporate IT, break your NuGet flow, and only half-block telemetry. But for greenfield Linux projects? Hell yeah.