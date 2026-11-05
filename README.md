# QE2027

A ready-made Linux desktop for DFT that runs in your web browser. Works on Mac, Windows and Linux.

## What's installed
- Quantum ESPRESSO 7.6 (full)
- PWTK 3.2
- XCrySDen
- Python and conda (numpy, scipy, matplotlib, ASE, pymatgen)
- QE Input Builder ([qeinput](https://github.com/sairajdream/qeinput))
- AI Helper ([free-ai-terminal](https://github.com/sairajdream/free-ai-terminal))
- Git, GitHub Sync and tmate

## You need
- 8 GB RAM or more
- 10 GB free disk space
- Internet for the first start (about 1.6 GB download)
- Permission to install apps on your laptop

---

## Step 1: Install Docker (one time)

<details>
<summary><b>Mac</b></summary>

1. Download **Docker Desktop for Mac** from https://www.docker.com/products/docker-desktop/
   (choose *Apple Silicon* or *Intel chip* to match your Mac).
2. Open the downloaded file and drag **Docker** into **Applications**.
3. Open **Docker**. Click **Accept**. Skip sign-in.
4. Wait until the whale 🐳 in the top menu bar stops moving.

</details>

<details>
<summary><b>Windows</b></summary>

1. Download **Docker Desktop for Windows** from https://www.docker.com/products/docker-desktop/
2. Run the installer. Keep **Use WSL 2** ticked.
3. Restart your laptop when asked.
4. Open **Docker Desktop**. Click **Accept**. Skip sign-in.
5. Wait until it shows **Engine running** (bottom left).

If it asks to update WSL: open **Command Prompt**, type `wsl --update`, press Enter.

</details>

<details>
<summary><b>Linux</b></summary>

1. Open a terminal and run:
   ```bash
   curl -fsSL https://get.docker.com | sudo sh
   sudo usermod -aG docker $USER
   ```
2. Log out and log back in.

</details>

## Step 2: Download QE2027

Download the file for your computer:

- **Mac:** [QE2027_Mac.zip](https://github.com/sairajdream/qe2027/releases/latest/download/QE2027_Mac.zip)
- **Windows:** [QE2027_Windows.zip](https://github.com/sairajdream/qe2027/releases/latest/download/QE2027_Windows.zip)
- **Linux:** [QE2027_Linux.zip](https://github.com/sairajdream/qe2027/releases/latest/download/QE2027_Linux.zip)

Unzip it:
- **Mac:** double-click the zip.
- **Windows:** right-click the zip > **Extract All** > **Extract**.
- **Linux:** right-click the zip > **Extract Here**.

You get one file: **QE2027**. Move it anywhere you like, for example to your Desktop.

## Step 3: Start

Make sure Docker is open first.

<details>
<summary><b>Mac</b></summary>

1. Double-click **QE2027.command**.
2. First time only, macOS blocks it:
   - Click **Done**.
   - Open **System Settings > Privacy & Security**.
   - Scroll down and click **Open Anyway**.
   - Double-click **QE2027.command** again.
3. Press **Enter** to start.

</details>

<details>
<summary><b>Windows</b></summary>

1. Double-click **QE2027.bat**.
2. First time only, if Windows says *"Windows protected your PC"*: click **More info** > **Run anyway**.
3. Press **Enter** to start.

</details>

<details>
<summary><b>Linux</b></summary>

1. In a terminal, in the folder with the file, run: `bash qe2027.sh`
2. Press **Enter** to start.

</details>

The first start downloads QE2027 (10 to 20 minutes, one time only). After that it starts in seconds.

Your browser opens the desktop at **http://localhost:6080**.

## Step 4: Stop

Open **QE2027** again, type **2** and press Enter.

Everything is kept for next time. Closing the browser does not stop QE2027; open http://localhost:6080 to go back.

---

## The menu

Every time you open QE2027 you get this menu:

| | What it does |
|---|---|
| **1 Start** | Starts QE2027, or continues where you left off |
| **2 Stop** | Pauses QE2027. Nothing is lost |
| **3 Update** | Gets the latest version (when the instructor asks you to) |
| **4 Reset** | Gives you a fresh system if something is broken |

Update and Reset keep your **dft_work** files, GitHub login and keys. Apps you installed yourself need to be installed again.

## Your files

Save your work in **My Work Folder** (desktop icon). It is the **dft_work** folder on your own computer:
- Mac: `/Users/<your name>/dft_work`
- Windows: `C:\Users\<your name>\dft_work`
- Linux: `/home/<your name>/dft_work`

You can open these files with your normal apps too. They are never deleted, even by Update or Reset.

## Quick tips

- Run QE in the Terminal: `mpirun -np 2 pw.x -in scf.in > scf.out`
- QE examples and pseudopotentials: `~/espresso`
- PWTK examples: `~/pwtk`
- Install more apps: `sudo apt update` then `sudo apt install <name>`, or `pip install <name>`.
- Copy and paste work as usual between your computer and QE2027:
  - **Mac:** Cmd+C and Cmd+V
  - **Windows and Linux:** Ctrl+V to paste. In the Terminal, copy with Ctrl+Shift+C.
  - Chrome or Edge may ask to **see your clipboard** once. Click **Allow** so right-click > Paste works too.
  - Safari and Firefox: paste with the keyboard (Cmd+V or Ctrl+V). Right-click > Paste does not work there.
  - A short message at the bottom of the screen shows each copy and paste.
- **GitHub Sync** (desktop icon) backs up your work to your GitHub account. Follow the steps it shows.

## Problems?

| Problem | Fix |
|---|---|
| "Docker is not installed" | Do Step 1. |
| "Docker didn't start" | Open Docker and wait until it's ready, then Start again. |
| "Download failed" | Check your internet and Start again. It continues where it stopped. |
| Browser says "can't connect" | Wait 10 seconds and reload. |
| Grey screen or "Disconnected" | Reload the page. |
| Calculation very slow or killed | Use `mpirun -np 1` and close other apps. |
| Something is broken | Use **4 Reset** in the menu. |

Still stuck? Send the instructor a screenshot.

## Remove QE2027

Stop QE2027, then run in Terminal (Mac, Linux) or Command Prompt (Windows):
```bash
docker rm -f qe2027
docker rmi ghcr.io/sairajdream/qe2027:latest
docker volume rm qe2027-persist
```
Your dft_work folder is not deleted.

---
Instructor: Dr Sai Raj Ali
