# 🎨 Voronoi Diagram Generator (8086/87 Assembly)  

A **simple Voronoi diagram generator** written in **8086/87 assembly** using **VGA graphics mode 13h**. This program demonstrates a basic (though computationally inefficient) approach to generating **Voronoi diagrams** through **brute force distance calculation**.  

## 📜 Description  

🖼️ This program generates a **Voronoi diagram** by:  
1️⃣ Creating **50 random points** on the screen 🎯  
2️⃣ Computing the **closest point** for each pixel using **distance calculations** 📏  
3️⃣ Coloring regions based on their closest point 🎨  
4️⃣ Displaying the result in **VGA graphics mode (320x200 resolution)** 🖥️  

## ⚙️ Prerequisites  

🔧 **Required Software:**  
- **NASM** (Netwide Assembler) for compiling the assembly code 🛠️  
- **DOSBox** for running the compiled program (since this is a **DOS real-mode** program) 💾  

---

## 🏗️ Compilation  

To compile the program, use **NASM** with the following command:  

```bash
nasm voronoi.asm -o voronoi.com -f bin
```

---

## 💻 Installation & Usage (Platform-Specific)  

### 🏁 Windows  

1️⃣ **Install DOSBox** from the [official website](https://www.dosbox.com/download.php?main=1)  
2️⃣ **Install NASM** from [NASM's website](https://www.nasm.us/)  
3️⃣ **Add NASM to your system's PATH**  
4️⃣ **Create a directory** for DOS programs (e.g., `C:\dosprogs`)  
5️⃣ **Copy `voronoi.asm`** to this directory  
6️⃣ **Mount the directory in DOSBox**:  
   ```dos
   mount c c:\dosprogs
   c:
   ```
7️⃣ **Compile & Run**:  
   ```dos
   nasm voronoi.asm -o voronoi.com -f bin
   voronoi.com
   ```

---

### 🍏 macOS  

1️⃣ **Install DOSBox** using Homebrew:  
   ```bash
   brew install dosbox
   ```  
2️⃣ **Install NASM**:  
   ```bash
   brew install nasm
   ```  
3️⃣ **Create a directory** for DOS programs:  
   ```bash
   mkdir ~/dosprogs
   ```  
4️⃣ **Copy `voronoi.asm`** to this directory  
5️⃣ **Launch DOSBox & Mount the directory**:  
   ```dos
   mount c ~/dosprogs
   c:
   ```
6️⃣ **Compile & Run**:  
   ```dos
   nasm voronoi.asm -o voronoi.com -f bin
   voronoi.com
   ```

---

### 🐧 Linux  

1️⃣ **Install DOSBox** using your package manager:  
   ```bash
   # Ubuntu/Debian
   sudo apt-get install dosbox

   # Fedora
   sudo dnf install dosbox

   # Arch Linux
   sudo pacman -S dosbox
   ```  
2️⃣ **Install NASM**:  
   ```bash
   # Ubuntu/Debian
   sudo apt-get install nasm

   # Fedora
   sudo dnf install nasm

   # Arch Linux
   sudo pacman -S nasm
   ```  
3️⃣ **Create a directory** for DOS programs:  
   ```bash
   mkdir ~/dosprogs
   ```  
4️⃣ **Copy `voronoi.asm`** to this directory  
5️⃣ **Launch DOSBox & Mount the directory**:  
   ```dos
   mount c ~/dosprogs
   c:
   ```
6️⃣ **Compile & Run**:  
   ```dos
   nasm voronoi.asm -o voronoi.com -f bin
   voronoi.com
   ```

---

## ▶️ Program Execution  

📌 **Once running, the program will:**  
✔️ Switch to **VGA graphics mode** (Mode 13h) 🖥️  
✔️ Generate **50 random points** 🎯  
✔️ Compute and **display the Voronoi diagram** 🎨  
✔️ Mark generator points in **black** ⚫  

🛑 **Press any key to exit the program.**  

---

## 🔧 Troubleshooting  

⚠️ **If DOSBox runs too fast/slow**, adjust CPU cycles using:  
   - **Ctrl + F11** to decrease speed  
   - **Ctrl + F12** to increase speed  

⚠️ **If `nasm` is not found**, make sure it's correctly installed and added to your system's PATH.  

⚠️ **For graphics issues**, try adjusting DOSBox's display settings in the configuration file (`dosbox.conf`).  

---

## 🔬 Technical Details  

- **Resolution:** 🖥️ 320x200 pixels (VGA mode 13h)  
- **Number of points:** 50 (**defined by `POINTS_COUNT`**)  
- **Uses** 🏗️ **8087 FPU** for floating-point calculations  
- **Implements** a **brute-force method** for distance calculations 📏  

---

## 📚 About Voronoi Diagrams  

A **Voronoi diagram** is a partitioning of a plane into **regions based on distance** to points in a specific subset of the plane.  

Each **region (Voronoi cell)** consists of all points closer to a specific **generator point** than to any other point.  

This concept has applications in:  
🔹 **Computer Graphics**  
🔹 **Geographic Information Systems (GIS)**  
🔹 **Machine Learning**  
🔹 **Clustering Analysis**  

---

## 📝 License  

📜 This project is **open-source** under the **MIT License**.