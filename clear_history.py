import subprocess
import time
import re

def run_adb(cmd):
    """Executes an ADB shell command and returns output"""
    result = subprocess.run(f"adb shell {cmd}", shell=True, capture_output=True, text=True)
    return result.stdout.strip()

def tap(x, y):
    """Taps at screen coordinate (x, y)"""
    run_adb(f"input tap {x} {y}")

def swipe(x1, y1, x2, y2, duration=400):
    """Performs a controlled swipe gesture"""
    run_adb(f"input swipe {x1} {y1} {x2} {y2} {duration}")

def get_screen_resolution():
    """Detects connected phone's screen resolution"""
    output = run_adb("wm size")
    match = re.search(r"(\d+)x(\d+)", output)
    if match:
        return int(match.group(1)), int(match.group(2))
    return 720, 1604  # Default fallback

def main():
    print("=" * 60)
    print("  Instagram Watch History Auto-Cleaner (Python + ADB)")
    print("=" * 60)

    # 1. Check ADB connection
    devices_output = subprocess.run("adb devices", shell=True, capture_output=True, text=True).stdout
    print("\nConnected Devices:\n" + devices_output.strip())

    if "device" not in devices_output:
        print("\n[ERROR] No authorized Android device detected.")
        print("Please enable USB Debugging and tap 'Allow' on your phone.")
        return

    # 2. Resolution detection
    width, height = get_screen_resolution()
    print(f"\n[INFO] Detected Screen Resolution: {width}x{height}")

    # Column X centers for 3-column layout
    col1 = int(width * (1 / 6))   # ~120 on 720p
    col2 = int(width * (3 / 6))   # ~360 on 720p
    col3 = int(width * (5 / 6))   # ~600 on 720p

    # Row Y centers (Row 1 & Row 2)
    row1 = int(height * 0.28)     # ~460 on 1604p
    row2 = int(height * 0.55)     # ~890 on 1604p

    batch_points = [
        (col1, row1), (col2, row1), (col3, row1),
        (col1, row2), (col2, row2), (col3, row2)
    ]

    # Swipe parameters (clears 2 full rows off-screen)
    swipe_x = int(width * 0.50)
    swipe_start_y = int(height * 0.78)
    swipe_end_y = int(height * 0.22)

    print("\nInstructions:")
    print("1. Open Instagram on your phone.")
    print("2. Navigate to: Profile -> Menu (3 lines) -> Your activity -> Watch history.")
    print("3. Tap 'Select' in the top-right corner.")
    print("-" * 60)

    input("Press ENTER when you are ready on the 'Select' screen...")

    print("\nStarting in 3 seconds... Do not touch your phone screen!")
    time.sleep(3)

    total_batches = 15
    for batch in range(1, total_batches + 1):
        print(f"Batch {batch} of {total_batches} - Selecting 6 videos...")
        for x, y in batch_points:
            tap(x, y)
            time.sleep(0.13)

        # Large clean swipe to push selected rows off screen
        swipe(swipe_x, swipe_start_y, swipe_x, swipe_end_y, 400)
        time.sleep(0.9)

    print("\n" + "=" * 60)
    print("Finished selecting videos!")
    print("Now look at your phone and tap 'Delete' at the bottom.")
    print("=" * 60)

if __name__ == "__main__":
    main()
