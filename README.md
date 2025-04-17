# **C# Minimalist: A Privacy-Focused .NET Environment**  
**Control your tooling. Reduce telemetry. Maintain autonomy.**

---

## 🎯 Purpose  
Modern .NET tools include telemetry by default, which can complicate privacy-focused workflows. This toolkit helps developers:  
- **Minimize external data transmission**  
- **Run .NET with local, isolated dependencies**  
- **Understand and control network behavior**  

No ideology—just configuration for engineers who value transparency.  

---

## 🛠️ Core Features  

### ✅ Controlled Environment  
- **Local .NET SDK Only**  
  Installs in your project directory—no global footprint. Remove with a single `rm`.  
- **Telemetry Mitigation**  
  Disables CLI telemetry, blocks known endpoints via firewall rules (Linux/macOS), and enforces `DOTNET_CLI_TELEMETRY_OPTOUT`.  
- **Supply Chain Verification**  
  Validates SDK downloads against Microsoft’s published SHA512 hashes.  

### 🧩 Open Tooling  
- **VSCode Cleanup**  
  Replaces proprietary "Dev Kit" with OpenVSX extensions (documentation included).  
- **NuGet Feed Reset**  
  Removes default package sources—add only the registries *you* audit.  

### 📡 Network Transparency  
- **Firewall Rules**  
  UFW/iptables templates to restrict outbound .NET traffic (Windows guidance provided).  
- **Diagnostic Tools**  
  Preconfigured mitmproxy commands to inspect network activity during builds.  

---

## 👷 Who Should Use This  

### ✅ Ideal Use Cases  
- Teams requiring compliance with data sovereignty policies  
- Developers debugging performance-sensitive or regulated applications  
- Engineers building air-gapped or firewall-restricted environments  

### ⚠️ Not Recommended For  
- Projects needing seamless Microsoft ecosystem integration  
- Teams unwilling to maintain custom NuGet feeds  
- Developers unfamiliar with firewall/CLI configuration  

---

## ⚙️ Usage  

### 1. Initialize Environment  
```bash  
git clone https://github.com/your-repo/csharp_minimalist.git  
cd csharp_minimalist  
./configure.sh --project YOUR_PROJECT.csproj  
```  

### 2. Review Network Rules (Optional)  
```bash  
# Linux/macOS  
nano config/ufw_rules.conf  

# Windows  
notepad config/windows_firewall.ps1  
```  

### 3. Build with Monitoring  
```bash  
mitmproxy -s scripts/mitmproxy_dotnet.py -- ./build.sh  
```  

---

## 🧩 Modular Design  

| Component               | Purpose                                  | Customization Guide                  |  
|-------------------------|------------------------------------------|--------------------------------------|  
| `local_sdk/`           | Isolated .NET 6.0+ installation          | Swap SDK versions via `sdk_version` |  
| `firewall/`            | Prebuilt UFW/Windows rules               | Add/remove IP ranges as needed       |  
| `vscode/`              | Telemetry-free VSCode configuration      | Extend with OpenVSX extensions       |  

---

## 🔍 Audit & Compliance  

### Verification Steps  
1. **Review Firewall Rules**  
   ```bash  
   cat firewall/ufw_rules.conf | grep "Outbound Deny"  
   ```  
2. **Check Telemetry Status**  
   ```bash  
   dotnet --info | grep "Telemetry"  
   ```  
3. **Validate SDK Integrity**  
   ```bash  
   sha512sum -c sdk_hashes.txt  
   ```  

---

## 🕵️ Enhanced Security Tools
<details>
<summary><strong>Click to Expand</strong></summary>


- **[mitmproxy](https://mitmproxy.org/)** – Monitor .NET's network behavior in real time.

  ```bash
  mitmproxy --mode transparent --showhost
  ```


- **[iptables](https://linux.die.net/man/8/iptables)** – Block unauthorized outbound traffic.

  ```bash
  iptables -A OUTPUT -d 13.107.9.2 -j DROP
  ```


- **Compile .NET from Source** –  

  Requires significant effort and tolerance for complexity.  

  ```bash
  s/Telemetry/\/\/ Telemetry/g
  ```


</details>
---

## Why This Approach?  

1. **Precision > Brute Force**  
   Targets specific telemetry subsystems rather than blanket blocking.  

2. **Adaptability**  
   Rulesets and configs update independently of SDK versions.  

3. **Transparency**  
   Every mitigation is documented and reversible.  

---

## 📆 Roadmap  

- [ ] Windows Group Policy templates  
- [ ] CI/CD pipeline integration guide  
- [ ] Automated telemetry endpoint auditing  

---

## License  
GNU GPLv3 with **Clinical Neutrality Clause**:  
*"This software may not be marketed as ‘anti-Microsoft’ or repurposed for ideological campaigns."*  

--- 

This isn’t rebellion—it’s engineering due diligence.