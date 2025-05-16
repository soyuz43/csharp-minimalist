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

## ⚠️ Operational Realities  

### **Telemetry Requires Vigilance**  
- We block known Microsoft endpoints. 
- New telemetry servers emerge frequently.  


### **NuGet Feed Management**  
- Default feeds (`api.nuget.org`) are **removed intentionally**.  
- Builds fail until you explicitly define trusted sources.  
- **Rationale:** Avoid implicit reliance on external registries.  

### **Windows Limitations**  
- No automated firewall rule configuration.  
- Requires manual setup with:  
  - `xmlstarlet` (modify `.csproj`/`.config` files)  
  - PowerShell firewall scripting  
- **Translation:** Windows support assumes sysadmin-level skills.  

---

## 👷 Target Audience  

### ✅ Recommended For  
| Use Case                  | Alignment with Realities               |  
|---------------------------|----------------------------------------|  
| Data sovereignty compliance | Explicit feed control + network blocking |  
| Regulated environments     | Audit-ready via `mitmproxy` captures    |  
| Air-gapped deployments     | No default NuGet dependency            |  

### ❌ Not Recommended For  
| Scenario                     | Conflict with Realities               |  
|------------------------------|---------------------------------------|  
| Microsoft ecosystem integration | Removed telemetry breaks VS tooling   |  
| Rapid prototyping            | Manual NuGet config slows iteration   |  
| GUI-only Windows developers  | Requires CLI/firewall expertise       |  
---

## ⚙️ Usage  

### 1. Initialize Environment  
```bash  
git clone https://github.com/soyuz43/csharp_minimalist.git  
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
