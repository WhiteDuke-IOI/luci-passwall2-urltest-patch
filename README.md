# LuCI PassWall 2 URL Test Patch 🚀

A lightweight shell script to add a dedicated "Test All URLs" button to the PassWall 2 Node List interface in OpenWrt.

---

### **About the Project**
When you have a large number of nodes/configurations in the PassWall 2 plugin, clicking the "Test" button for each individual node to check the latency (ping) can be tedious and time-consuming.

This patch automatically injects a smart **"Test All URLs"** button directly into the nodes toolbar. With just a single click, it sequentially triggers the URL test for all available configurations with a safe, optimized delay to prevent UI freezing.

**Smart Multi-Architecture & Core Protection**

* **Universal Dynamic Injection:** The installer script (`patch.sh`) safely injects a lightweight payload directly into the interface without overwriting native system files, ensuring 100% immunity against upstream PassWall Lua core updates and preventing UI crashes.
* **Structural Proxy & Metadata Protection:** Virtual configurations such as **Shunt**, **Balancing (Load Balancer)**, and **URLTest** engines, as well as descriptive/traffic info nodes (e.g., remaining GB, expiration dates), are strictly shielded from accidental bulk selection!
* **Smart Health-Aware Selection:** If all proxies are healthy, the patch automatically notifies you without prompting for deletion. Confirmation and auto-ticking are strictly triggered only when dead or timed-out proxies exist.

### **Features**
* **Zero-Risk Injection:** Operates directly on the DOM layer without replacing system files, keeping native router firmware components completely untouched.
* **Theme Companion:** Fully equipped with a theme scheme detector that automatically shifts button styles to fit perfectly in both Light and high-contrast Dark LuCI layouts.
* **Idempotent Script:** Safe to run multiple times; it will never create duplicate buttons or break your existing structure.
* **One-Click Install:** No extra desktop tools (like WinSCP) required.
* **Network Guard:** Embedded with a 20-second timeout guard for slow connections and strict directory validation to prevent bricking incompatible systems.

### **🛠 Installation**
Open your router's terminal via SSH (e.g., PuTTY), paste the following command, and press Enter:

<pre><code>wget -qO- https://raw.githubusercontent.com/WhiteDuke-IOI/luci-passwall2-urltest-patch/main/patch.sh | sh</code></pre>

### **🔄 Final Step**
After running the script, go to your router's web interface, navigate to the PassWall 2 -> Node List page, and press **Ctrl + F5** in your browser to clear the browser cache and see the new button.

### **⏪ Uninstallation & Recovery**

If you ever need to remove the patch and restore your system to its factory layout, you can choose one of the following methods:

#### **Method 1: 🔌 Local Offline Method (Highly Recommended)**
You don't even need an internet connection! A dedicated local command is automatically generated on your router during installation. Simply type this word in your SSH terminal and hit Enter:

<pre><code>passwall2-urltest-uninstall</code></pre>

#### **Method 2: 🌐 Online Method**
Alternatively, you can run the uninstallation trigger directly from GitHub:

<pre><code>wget -qO- https://raw.githubusercontent.com/WhiteDuke-IOI/luci-passwall2-urltest-patch/main/patch.sh | sh -s uninstall</code></pre>

*Note: Both methods will cleanly strip the injected code, purge the LuCI cache, and restore the factory layout without touching your configurations.*
