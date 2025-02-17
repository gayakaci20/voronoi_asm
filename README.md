# 🎨 Générateur de Diagramme de Voronoï (8086/87 Assembleur)  

Un **générateur de diagramme de Voronoï** écrit en **assembleur 8086/87** utilisant le **mode graphique VGA 13h**. Ce programme démontre une **méthode brute** (bien que peu efficace) pour générer des **diagrammes de Voronoï** à l'aide de **calculs de distances**.  

---

## 📜 Description  

🖼️ Ce programme génère un **diagramme de Voronoï** en :  
1️⃣ Créant **50 points aléatoires** sur l'écran 🎯  
2️⃣ Calculant le **point le plus proche** pour chaque pixel grâce aux **distances euclidiennes** 📏  
3️⃣ Colorant les régions en fonction du point le plus proche 🎨  
4️⃣ Affichant le résultat en **mode graphique VGA (320x200 pixels)** 🖥️  

---

## ⚙️ Prérequis  

🔧 **Logiciels requis :**  
- **NASM** (Netwide Assembler) pour compiler le code assembleur 🛠️  
- **DOSBox** pour exécuter le programme compilé (car c'est un programme DOS en mode réel) 💾  

---

## 🏗️ Compilation  

Pour compiler le programme, utilisez **NASM** avec la commande suivante :  

```bash
nasm voronoi.asm -o voronoi.com -f bin
```

---

## 💻 Installation & Utilisation (Selon le Système d’Exploitation)  

### 🏁 Windows  

1️⃣ **Installez DOSBox** depuis le [site officiel](https://www.dosbox.com/download.php?main=1)  
2️⃣ **Installez NASM** depuis [le site de NASM](https://www.nasm.us/)  
3️⃣ **Ajoutez NASM au PATH de votre système**  
4️⃣ **Créez un dossier** pour vos programmes DOS (ex. `C:\dosprogs`)  
5️⃣ **Copiez `voronoi.asm`** dans ce dossier  
6️⃣ **Montez le dossier dans DOSBox** :  
   ```dos
   mount c c:\dosprogs
   c:
   ```
7️⃣ **Compilez & Exécutez** :  
   ```dos
   nasm voronoi.asm -o voronoi.com -f bin
   voronoi.com
   ```

---

### 🍏 macOS  

1️⃣ **Installez DOSBox** avec Homebrew :  
   ```bash
   brew install dosbox
   ```  
2️⃣ **Installez NASM** :  
   ```bash
   brew install nasm
   ```  
3️⃣ **Créez un dossier** pour vos programmes DOS :  
   ```bash
   mkdir ~/dosprogs
   ```  
4️⃣ **Copiez `voronoi.asm`** dans ce dossier  
5️⃣ **Lancez DOSBox & montez le dossier** :  
   ```dos
   mount c ~/dosprogs
   c:
   ```
6️⃣ **Compilez & Exécutez** :  
   ```dos
   nasm voronoi.asm -o voronoi.com -f bin
   voronoi.com
   ```

---

### 🐧 Linux  

1️⃣ **Installez DOSBox** avec votre gestionnaire de paquets :  
   ```bash
   # Ubuntu/Debian
   sudo apt-get install dosbox

   # Fedora
   sudo dnf install dosbox

   # Arch Linux
   sudo pacman -S dosbox
   ```  
2️⃣ **Installez NASM** :  
   ```bash
   # Ubuntu/Debian
   sudo apt-get install nasm

   # Fedora
   sudo dnf install nasm

   # Arch Linux
   sudo pacman -S nasm
   ```  
3️⃣ **Créez un dossier** pour vos programmes DOS :  
   ```bash
   mkdir ~/dosprogs
   ```  
4️⃣ **Copiez `voronoi.asm`** dans ce dossier  
5️⃣ **Lancez DOSBox & montez le dossier** :  
   ```dos
   mount c ~/dosprogs
   c:
   ```
6️⃣ **Compilez & Exécutez** :  
   ```dos
   nasm voronoi.asm -o voronoi.com -f bin
   voronoi.com
   ```

---

## ▶️ Exécution du Programme  

📌 **Une fois en cours d'exécution, le programme va :**  
✔️ Passer en **mode graphique VGA (13h)** 🖥️  
✔️ Générer **50 points aléatoires** 🎯  
✔️ Calculer et **afficher le diagramme de Voronoï** 🎨  
✔️ Marquer les **points générateurs** en **noir** ⚫  

🛑 **Appuyez sur une touche pour quitter le programme.**  

---

## 🔧 Dépannage  

⚠️ **Si DOSBox est trop rapide ou trop lent**, ajustez la vitesse avec :  
   - **Ctrl + F11** pour ralentir  
   - **Ctrl + F12** pour accélérer  

⚠️ **Si `nasm` n'est pas reconnu**, assurez-vous qu'il est bien installé et ajouté au PATH du système.  

⚠️ **Si vous rencontrez des problèmes graphiques**, essayez de modifier les paramètres d'affichage dans le fichier de configuration de DOSBox (`dosbox.conf`).  

---

## 🔬 Détails Techniques  

- **Résolution :** 🖥️ 320x200 pixels (**mode VGA 13h**)  
- **Nombre de points :** 50 (**défini par `POINTS_COUNT`**)  
- **Utilise** 🏗️ **le coprocesseur 8087** pour les calculs en virgule flottante  
- **Méthode brute** pour calculer les distances 📏  

---

## 📚 À propos des Diagrammes de Voronoï  

Un **diagramme de Voronoï** est une division d’un plan en **régions basées sur la distance** à certains points de référence.  

Chaque **région (cellule de Voronoï)** contient tous les points qui sont **plus proches** d'un certain **point générateur** que de tout autre point.  

🔹 **Applications :**  
✔️ **Graphisme informatique** 🎨  
✔️ **Systèmes d'information géographique (SIG)** 🗺️  
✔️ **Apprentissage automatique** 🤖  
✔️ **Analyse de regroupement (clustering)** 📊  

---

## 📝 Licence  

📜 Ce projet est **open-source** sous la **Licence MIT**.