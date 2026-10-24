# 📸 Instagram Watch History Auto-Cleaner

> Automate the batch selection and deletion of your Instagram Reels watch history on Android using ADB (Android Debug Bridge).

---

## 🧐 Why This Exists

Instagram allows you to view your watched Reels and videos under **Your activity → Watch history**, but it **does not provide a "Select All" or "Clear All" button**. 

If you have watched hundreds or thousands of Reels, manually tapping each tiny checkbox one by one takes forever. This tool automates the tapping and scrolling process directly on your connected phone via USB, selecting dozens of videos in seconds so you can delete them in bulk.

---

## ✨ Features

- **🚀 Dual Implementations:**
  - **PowerShell (`clear_history.ps1`)**: Runs natively out of the box on Windows with **zero Python installation needed**. Automatically downloads `adb` if missing!
  - **Python (`clear_history.py`)**: Cross-platform script for Python users.
- **📱 Auto Resolution Detection:** Automatically reads your phone screen resolution (e.g. 720x1604, 1080x2400) and calculates precise grid coordinates.
- **🎯 3-Column Grid Support:** Correctly selects videos across all 3 columns of the Reels feed.
- **🛡️ Safe & Ban-Free:** Unlike bots that reverse-engineer private API tokens, this simulates real physical touch taps on your device via ADB. Instagram cannot detect it as an automated account bot.
- **🔄 Anti-Double-Tap Logic:** Uses full-page swipe gestures to ensure previously selected videos are pushed completely off-screen, preventing accidental deselection.

---

## 📋 Prerequisites

1. **Android Phone:**
   - Enable **Developer Options**: Go to *Settings → About Phone* and tap *Build Number* 7 times.
   - Enable **USB Debugging**: Go to *Settings → Developer Options* and toggle **USB Debugging** ON.
2. **USB Cable:** Connect your phone to your computer.
3. **Authorize Connection:** When prompted on your phone screen with *"Allow USB debugging?"*, check *"Always allow from this computer"* and tap **Allow**.

---

## 🚀 Quick Start

### Option 1: Native Windows PowerShell (No Python Required)

1. Open Instagram on your phone:
   - Go to: **Profile (☰)** → **Your activity** → **Watch history**.
   - Tap **Select** in the top-right corner.
2. Open PowerShell in this folder and run:
   ```powershell
   powershell -ExecutionPolicy Bypass -File .\clear_history.ps1
   ```
3. Press **Enter** when prompted, and watch your phone automatically select videos!
4. Once completed, tap **Delete** at the bottom of your phone screen.

---

### Option 2: Python

1. Ensure ADB is installed and added to your PATH.
2. Open Instagram Watch History on your phone and tap **Select**.
3. Run the Python script:
   ```bash
   python clear_history.py
   ```
4. Press **Enter** and let the script select videos. Tap **Delete** when finished.

---

## ⚙️ Configuration

You can customize the number of batches/scrolls in either script:

In `clear_history.ps1`:
```powershell
$totalBatches = 15   # 15 batches x 6 videos = 90 videos selected
```

In `clear_history.py`:
```python
total_batches = 15   # Adjust to select more or fewer videos per run
```

---

## 🛠️ Troubleshooting

- **`unauthorized` in `adb devices`:** Unlock your phone and accept the "Allow USB debugging" prompt.
- **Device not detected:** Make sure your USB cable supports data transfer (not charge-only) and try a different USB port.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
