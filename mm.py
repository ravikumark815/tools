#!/usr/bin/env python3
"""
Keep your computer awake by simulating user activity.

Usage:
    python awake.py [interval_seconds]
    (Default interval is 540 seconds = 9 minutes)

Requirements:
    pip install pyautogui
"""

import pyautogui
import time
import random
import sys

interval = int(sys.argv[1]) if len(sys.argv) > 1 else 540

screenWidth, screenHeight = pyautogui.size()
print(f"Screen size detected: {screenWidth} x {screenHeight}")
print(f"Moving mouse every {interval} seconds. Press Ctrl+C to stop.")

try:
    while True:
        x = random.randint(0, screenWidth - 1)
        y = random.randint(0, screenHeight - 1)
        pyautogui.moveTo(x, y, duration=0.1)
        localtime = time.strftime("%I:%M:%S %p")
        print(f"[{localtime}] Moved mouse to ({x}, {y})")
        # Optionally, uncomment to add a click or keypress:
        # pyautogui.click()
        # pyautogui.press('shift')
        time.sleep(interval)
except KeyboardInterrupt:
    print("\nExiting keep-awake script. Goodbye!")