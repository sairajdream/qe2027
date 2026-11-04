# QE2027 — a ready-made DFT computer in your web browser

QE2027 gives you a complete Linux desktop **inside your web browser**, with everything needed for the workshop already installed:

**Quantum ESPRESSO 7.6** (pw.x, ph.x, neb.x, bands.x, projwfc.x, dos.x, …) · **PWTK 3.2** · **XCrySDen** · **Python + conda** (numpy, scipy, matplotlib, ASE, pymatgen) · **QE Input Builder** · **AI Helper** · **tmate** · **Git + GitHub Sync**

It works the same on **Mac, Windows and Linux**. You install one free program (**Docker**), download one zip file, and double-click **Start**. You don't need to know Linux commands to get started.

**Download:** **[tiny.cc/qe2027](https://tiny.cc/qe2027)**

---

## Contents
1. [What you need](#1-what-you-need)
2. [Which file should I download?](#2-which-file-should-i-download)
3. [Install Docker](#3-install-docker-one-time) ([Mac](#mac) · [Windows](#windows) · [Linux](#linux))
4. [Download and unzip QE2027](#4-download-and-unzip-qe2027)
5. [Start QE2027](#5-start-qe2027) ([Mac](#start-on-mac) · [Windows](#start-on-windows) · [Linux](#start-on-linux))
6. [Using the desktop](#6-using-the-desktop)
7. [Back up your work with GitHub](#7-back-up-your-work-with-github-optional)
8. [Stop QE2027](#8-stop-qe2027)
9. [Problems?](#9-problems)
10. [Updating and uninstalling](#10-updating-and-uninstalling)

---

## 1. What you need
- A laptop with at least **8 GB of memory (RAM)**. 16 GB is better.
- About **10 GB of free disk space**.
- An internet connection for the first download (about 1.6 GB). After that, QE2027 works **offline**.
- Administrator rights on the laptop to install Docker. College-managed laptops may block this; please check before the workshop.

## 2. Which file should I download?
Open **[tiny.cc/qe2027](https://tiny.cc/qe2027)**. There are two zip files. Download **only the one that matches your computer**:

| Your computer | Download |
|---|---|
| **Mac with Apple chip** (M1, M2, M3, M4, …) | **`QE2027_AppleChip_ARM.zip`** |
| **Windows** laptop (Intel or AMD processor; almost all Windows laptops) | **`QE2027_Intel_AMD.zip`** |
| **Linux** laptop (Intel or AMD) | **`QE2027_Intel_AMD.zip`** |
| **Mac with Intel processor** (older Macs) | **`QE2027_Intel_AMD.zip`** |
| Windows laptop with a **Snapdragon / ARM** processor (rare) | **`QE2027_AppleChip_ARM.zip`** |

**How to check:**
- **Mac:** Apple menu  → **About This Mac**. "Chip: Apple M…" means Apple chip. "Processor: Intel…" means Intel.
- **Windows:** Start → Settings → System → **About** → *System type*. "x64-based processor" means Intel/AMD. "ARM-based processor" means ARM.
- **Linux:** run `uname -m` in a terminal. `x86_64` means Intel/AMD. `aarch64` means ARM.

If you download the wrong one, Start tells you so. Nothing breaks.

## 3. Install Docker (one time)
Docker is the free program that runs QE2027. It is free for students, teachers and personal use.

### Mac
1. Go to **https://www.docker.com/products/docker-desktop/** and click **Download Docker Desktop**. Choose **Mac – Apple Silicon** or **Mac – Intel chip** to match your Mac.
2. Open the downloaded **`Docker.dmg`** and drag **Docker** into **Applications**.
3. Open **Docker** from Applications. Click **Accept** on the terms. You can **skip** sign-in and the survey.
4. Wait until the whale icon 🐳 in the top menu bar **stops moving**. Docker is now ready.

*8 GB Mac?* Docker Desktop → ⚙️ **Settings → Resources** → set **Memory to 4 GB** → **Apply & restart**.

### Windows
Windows 10 (version 22H2) or Windows 11 is needed.
1. Go to **https://www.docker.com/products/docker-desktop/** and click **Download for Windows – AMD64** (choose ARM64 only if you have a Snapdragon/ARM laptop).
2. Run **`Docker Desktop Installer.exe`**. Keep the option **"Use WSL 2 instead of Hyper-V"** ticked. Click **OK**, then **Close and restart** when it finishes.
3. After the restart, open **Docker Desktop** from the Start menu. Click **Accept**. You can **skip** sign-in and the survey.
4. If it asks you to **update WSL**, open the Start menu, type **`cmd`**, open **Command Prompt**, type `wsl --update`, press Enter and wait, then open Docker Desktop again.
5. Wait until the bottom-left corner of Docker Desktop shows **"Engine running"** (green).

If Docker says **"Virtualization support not detected"**, virtualization is switched off in your laptop's BIOS. Search the web for *"enable virtualization"* plus your laptop brand (it's called *Intel VT-x* or *AMD SVM*), or ask the instructor.

### Linux
Ubuntu, Debian, Mint, Fedora and most other distributions. Open a terminal and run:
```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
```
Then **log out and log back in** (or restart). Check it works with:
```bash
docker run --rm hello-world
```
It should print *"Hello from Docker!"*.

## 4. Download and unzip QE2027
1. Open **[tiny.cc/qe2027](https://tiny.cc/qe2027)** and download your zip (see [step 2](#2-which-file-should-i-download)). It is about **1.6 GB**.
   Google Drive says it **can't scan the file for viruses** because it is large. Click **Download anyway**.
2. Unzip it:
   - **Mac:** double-click the zip in your Downloads folder.
   - **Windows:** right-click the zip → **Extract All…** → **Extract**. Don't just double-click to look inside it: Start doesn't work from inside a zip.
   - **Linux:** right-click → **Extract Here**, or run `unzip QE2027_Intel_AMD.zip`.
3. You get a **`QE2027`** folder containing:

| File | What it is |
|---|---|
| `qe2027-arm64.tar.gz` or `qe2027-amd64.tar.gz` | the QE2027 system itself. **Don't open or unzip it** |
| `Start QE2027.command` / `Stop QE2027.command` | start and stop on **Mac** |
| `Start QE2027.bat` / `Stop QE2027.bat` | start and stop on **Windows** |
| `start_qe2027.sh` | start and stop on **Linux** (the Mac files use it too) |
| `start_qe2027.bat` | used by the Windows files |
| `README.txt` | these instructions |

Keep all of these files together in the same folder. You can move the folder anywhere you like, for example to Documents.

## 5. Start QE2027
Make sure Docker is running first (step 3).

The **first start** takes **1–3 minutes** while QE2027 loads into Docker. After that, it starts in a few seconds.
Your web browser then opens **http://localhost:6080** with the Linux desktop. If it doesn't open, type that address into Chrome, Safari, Edge or Firefox yourself.

### Start on Mac
1. Open the `QE2027` folder and double-click **`Start QE2027.command`**.
2. **First time only:** macOS says it *"cannot be opened"* or *"cannot verify the developer"*. Click **Done**.
   Open  → **System Settings → Privacy & Security**, scroll down, and click **Open Anyway** next to "Start QE2027.command". Enter your password if asked, then double-click **Start QE2027.command** again and click **Open**.
3. A Terminal window shows the progress, and then the browser opens. You can close the Terminal window; QE2027 keeps running.

### Start on Windows
1. Open the extracted `QE2027` folder and double-click **`Start QE2027.bat`**.
2. **First time only:** Windows may show *"Windows protected your PC"*. Click **More info** → **Run anyway**.
3. A black window shows the progress, and then the browser opens. When it says *"Press any key"*, you can close it; QE2027 keeps running.
4. If Windows Firewall asks about Docker, click **Allow**.

### Start on Linux
In a terminal, inside the `QE2027` folder:
```bash
bash start_qe2027.sh
```
The browser opens by itself. Other commands: `bash start_qe2027.sh stop` to stop it, and `bash start_qe2027.sh shell` for a terminal in QE2027 without the browser.

## 6. Using the desktop
- **Icons on the desktop** and the **bottom bar**: **Terminal**, **My Work Folder**, **XCrySDen**, **Text Editor**, **QE Input Builder**, **AI Helper** and **GitHub Sync**. The **Menu** button at the bottom left has everything else, with a search box.
- **Save your work in "My Work Folder"** (`~/work` inside QE2027). It is the **`dft_work` folder in your own home folder**:

  | | Your work folder |
  |---|---|
  | Mac | `/Users/<your name>/dft_work` |
  | Windows | `C:\Users\<your name>\dft_work` |
  | Linux | `/home/<your name>/dft_work` |

  So you can also open your results with your normal apps, and they stay after you stop QE2027. **Files saved anywhere else inside QE2027 are lost when you stop it.**
- **Run Quantum ESPRESSO** in the Terminal:
  ```bash
  cd ~/work
  mpirun -np 2 pw.x -in scf.in > scf.out
  ```
- **QE folder** (`~/espresso`): all QE programs in `bin/`, the official QE 7.6 **examples** (`PW/examples`, `PHonon/examples`, `NEB/examples`, `PP/examples`, …) and their **pseudopotentials** in `pseudo/`. To run an example:
  ```bash
  cd ~/espresso/PW/examples/example01
  ./run_example
  ```
  Then compare `results/` with `reference/`.
- **PWTK folder** (`~/pwtk`): PWTK documentation and examples.
  ```bash
  cd ~/pwtk/examples
  pwtk bands-Si.pwtk
  ```
- The `espresso` and `pwtk` folders reset to the original when you stop. **Copy anything you change into My Work Folder.**
- **QE Input Builder** (desktop icon, or type `qeinput` in the Terminal): build a molecule, bulk crystal, surface slab or nanotube, download a structure from the **Materials Project**, or convert a `.cif` / `.xyz` / `POSCAR` file. You get a ready-to-run `pw.x` input (scf, relax or vc-relax) with SSSP pseudopotentials and cutoffs filled in. **Always test convergence of cutoffs and k-points yourself.**
  For Materials Project downloads, get a free API key from https://next-gen.materialsproject.org/api. In the Terminal, type `bashrc`, add the line `export MP_API_KEY='your_key'`, then save and quit (`Esc`, then `:wq`, then Enter). The key is kept after restarts.
- **AI Helper** (desktop icon, or `ai` in the Terminal): ask about Linux commands and error messages in plain English, e.g. `ai how do I copy a folder` or `ai pw.out what went wrong`. Type `ai fix` when a command fails.
  First time: type `ai keys` and paste free keys from https://console.groq.com/keys and https://console.mistral.ai/api-keys (no credit card needed). Your keys stay on your computer and are never sent to the AI.
  **The AI is often confident and wrong.** Never trust it for physics, numbers or results.
- **Copy and paste** between your computer and QE2027: open the small tab on the **left edge** of the browser page → **Clipboard**.
- **Full screen** gives you more space: Ctrl+Cmd+F on Mac, F11 on Windows and Linux. The desktop resizes to fit.
- Handy commands: `gedit file.in` (text editor), `du` (folder sizes), `tmsg` (tmate messages), `gitreset` (undo your changes to a downloaded repository).

## 7. Back up your work with GitHub (optional)
Double-click **GitHub Sync** on the desktop.
- **First time:** it shows a code like `ABCD-1234`. Press **Enter** for each question. On your computer, open **https://github.com/login/device**, type the code and click **Authorize**. (No account? Create a free one at github.com first.) You stay signed in after this.
- Choose **1** to back up My Work Folder to a **private** repository called `dft-work` in your GitHub account. Do this at the end of each session. On another computer, choosing 1 brings your files there too.
- Choose **2** and press **Enter** to download the workshop material. Do this again later to get updates. You can also paste the link of any other repository.
- Very large files (over 50 MB) and QE's temporary files are skipped automatically.

## 8. Stop QE2027
| | |
|---|---|
| Mac | double-click **`Stop QE2027.command`** |
| Windows | double-click **`Stop QE2027.bat`** |
| Linux | `bash start_qe2027.sh stop` |

Closing the browser tab does **not** stop QE2027. To go back to where you were, just open **http://localhost:6080** again.
When you're done for the day, stop QE2027 and you can also quit Docker Desktop to free memory.

## 9. Problems?
| What you see | What to do |
|---|---|
| "Docker is not installed" | Do [step 3](#3-install-docker-one-time). |
| "Docker didn't start" | Open Docker Desktop and wait until it's ready (whale 🐳 stops moving on Mac, "Engine running" on Windows), then Start again. |
| "This is the wrong download for your computer" | Download the other zip (see [step 2](#2-which-file-should-i-download)). |
| "Can't find …tar.gz" | Keep the `.tar.gz` file in the same folder as Start. On Windows, make sure you used **Extract All**. |
| Mac: "cannot be opened" / "unidentified developer" | See the first-time step in [Start on Mac](#start-on-mac). |
| Windows: "Windows protected your PC" | Click **More info** → **Run anyway**. |
| Windows: "Virtualization support not detected" / WSL errors | See the notes under [Windows](#windows). |
| Linux: "permission denied … docker.sock" | Run `sudo usermod -aG docker $USER`, then log out and back in. |
| Linux: can't save files in My Work Folder | Install the `acl` package (`sudo apt install acl`), then Stop and Start again. |
| Browser says "can't connect" | Wait 10 seconds and reload. If it still fails, Stop and then Start again. |
| Grey screen or "Disconnected" | Reload the browser page. |
| A calculation is killed or very slow | Use fewer cores (`mpirun -np 1`), close other apps, or give Docker more memory (Docker Desktop → Settings → Resources). |
| Something else | Contact the instructor with a screenshot of the Start window. |

## 10. Updating and uninstalling
- **New version:** download the new zip, unzip it, and double-click its Start. It replaces the old version automatically. **Your work folder, GitHub login and keys are kept.** You can then delete the old QE2027 folder.
- **After the first start**, you can delete the downloaded zip to save 1.6 GB. Keep the unzipped folder: you need it to start and stop.
- **Remove QE2027 completely:** stop it, then run these commands in Terminal (Mac/Linux) or Command Prompt (Windows):
  ```bash
  docker rm -f qe2027
  docker rmi qe2027:1.0
  docker volume rm qe2027-persist
  ```
  This deletes QE2027, your keys and your GitHub login. Your `dft_work` folder is **not** deleted. You can then uninstall Docker Desktop like any other app.

---
Workshop instructor: **Sai Raj Ali**. Quantum ESPRESSO (https://www.quantum-espresso.org) and PWTK (https://pwtk.ijs.si) are free software by their respective authors.
