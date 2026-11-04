# QE2027

A ready-made Linux desktop for DFT that runs in your web browser. Works on Mac, Windows and Linux.

**Download:** [tiny.cc/qe2027](https://tiny.cc/qe2027)

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

Open [tiny.cc/qe2027](https://tiny.cc/qe2027) and download **one** file:

| Your computer | Download |
|---|---|
| Mac with Apple chip (M1, M2, M3, M4) | `QE2027_AppleChip_ARM.zip` |
| Windows, Linux, or Mac with Intel chip | `QE2027_Intel_AMD.zip` |

Not sure? On a Mac: Apple menu  > **About This Mac**. "Chip: Apple M..." means Apple chip.

If Google Drive says it can't scan the file for viruses, click **Download anyway**.

## Step 3: Unzip

- **Mac:** double-click the zip.
- **Windows:** right-click the zip > **Extract All** > **Extract**.
- **Linux:** right-click the zip > **Extract Here**.

You now have a **QE2027** folder. Keep all files in it together.

## Step 4: Start

Make sure Docker is open first. The first start takes 1 to 3 minutes. Your browser then opens the desktop at **http://localhost:6080**.

<details>
<summary><b>Mac</b></summary>

1. Double-click **Start QE2027.command**.
2. First time only, macOS blocks it:
   - Click **Done**.
   - Open **System Settings > Privacy & Security**.
   - Scroll down and click **Open Anyway**.
   - Double-click **Start QE2027.command** again.

</details>

<details>
<summary><b>Windows</b></summary>

1. Double-click **Start QE2027.bat**.
2. First time only, if Windows says *"Windows protected your PC"*: click **More info** > **Run anyway**.

</details>

<details>
<summary><b>Linux</b></summary>

In a terminal, inside the QE2027 folder:
```bash
bash start_qe2027.sh
```

</details>

## Step 5: Stop

- **Mac:** double-click **Stop QE2027.command**
- **Windows:** double-click **Stop QE2027.bat**
- **Linux:** `bash start_qe2027.sh stop`

Closing the browser does not stop QE2027. Open http://localhost:6080 to go back.

---

## Save your work

Always save in **My Work Folder** (desktop icon). Anything saved elsewhere is lost when you stop.

My Work Folder is the **dft_work** folder on your own computer:
- Mac: `/Users/<your name>/dft_work`
- Windows: `C:\Users\<your name>\dft_work`
- Linux: `/home/<your name>/dft_work`

## Quick tips

- Run QE in the Terminal: `mpirun -np 2 pw.x -in scf.in > scf.out`
- QE examples and pseudopotentials: `~/espresso`
- PWTK examples: `~/pwtk`
- Copy and paste with your computer: small tab on the left edge of the browser > **Clipboard**.
- **GitHub Sync** (desktop icon) backs up your work to your GitHub account. Follow the steps it shows.

## Problems?

| Problem | Fix |
|---|---|
| "Docker is not installed" | Do Step 1. |
| "Docker didn't start" | Open Docker and wait until it's ready, then Start again. |
| "Wrong download for your computer" | Download the other zip (Step 2). |
| "Can't find ...tar.gz" | Windows: use **Extract All** (Step 3). |
| Browser says "can't connect" | Wait 10 seconds and reload. |
| Grey screen or "Disconnected" | Reload the page. |
| Calculation very slow or killed | Use `mpirun -np 1` and close other apps. |

Still stuck? Send the instructor a screenshot.

## Update or remove

- **Update:** download the new zip and Start it. Your files and settings are kept.
- **Remove:** stop QE2027, then run:
  ```bash
  docker rm -f qe2027
  docker rmi qe2027:1.0
  docker volume rm qe2027-persist
  ```
  Your dft_work folder is not deleted.

---
Instructor: Sai Raj Ali
