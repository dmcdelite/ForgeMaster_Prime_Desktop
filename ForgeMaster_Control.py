import os
import json
import subprocess
from datetime import datetime

try:
    from ForgeMaster_Injector import inject_code_to_wow
except ImportError:
    def inject_code_to_wow(code):
        print(">>> ForgeMaster_Injector is not installed. Injection is unavailable.")

HISTORY_FILE = os.path.join(os.path.dirname(__file__), "forgemaster_history.json")

def load_history():
    if os.path.exists(HISTORY_FILE):
        try:
            with open(HISTORY_FILE, "r") as f:
                return json.load(f)
        except (json.JSONDecodeError, IOError):
            return []
    return []

def save_history(history):
    with open(HISTORY_FILE, "w") as f:
        json.dump(history, f, indent=2)

def log_history(entry_type, message):
    history = load_history()
    history.append({
        "type": entry_type,
        "message": message,
        "timestamp": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
    })
    save_history(history)

def search_history(query=""):
    history = load_history()
    if not history:
        print(">>> No history found.")
        return
    q = query.lower().strip()
    matches = [e for e in history if q == "" or q in e["message"].lower()]
    header = f"History - search: '{query}'" if q else "History (all entries)"
    print(f"\n=== ForgeMaster {header} ===")
    if matches:
        for entry in matches:
            print(f"  [{entry['timestamp']}] {entry['type']}: {entry['message']}")
    else:
        print("  No matching history entries.")
    print()

BLP_TOOL = os.path.join(os.path.dirname(__file__), "blp2png.exe")

def convert_blp_to_png():
    """Convert the most recently modified .blp file in the current directory to PNG."""
    blp_files = [f for f in os.listdir(".") if f.lower().endswith(".blp")]
    if not blp_files:
        print(">>> No .blp files found in the current directory.")
        return
    latest = max(blp_files, key=lambda f: os.path.getmtime(f))
    out = os.path.splitext(latest)[0] + ".png"
    if not os.path.exists(BLP_TOOL):
        print(f">>> BLP converter not found at: {BLP_TOOL}")
        print("    Place blp2png.exe next to this script and try again.")
        return
    result = subprocess.run([BLP_TOOL, latest, out])
    if result.returncode == 0:
        print(f">>> Converted: {latest} -> {out}")
        log_history("blp_convert", f"{latest} -> {out}")
    else:
        print(f">>> Conversion failed (exit code {result.returncode}).")

def main_menu():
    while True:
        print("\n=== ForgeMaster Prime Desktop Control ===")
        print("1. Inject 'Fix_Taint.lua' to Workbench")
        print("2. Sync VS Code Clipboard to WoW")
        print("3. Convert last BLP to PNG")
        print("4. Search Previous Chat/Scan History")
        print("5. Exit")

        choice = input("Select Option: ").strip()

        if choice == "1":
            taint_path = os.path.join(os.path.dirname(__file__), "Fix_Taint.lua")
            if not os.path.exists(taint_path):
                print(f">>> Fix_Taint.lua not found at: {taint_path}")
            else:
                with open(taint_path, "r") as f:
                    code = f.read()
                inject_code_to_wow(code)
                log_history("inject", "Fix_Taint.lua")
                print(">>> Fix_Taint.lua injected to ForgeMaster Workbench!")

        elif choice == "2":
            try:
                import tkinter as tk
            except ImportError:
                print(">>> tkinter is not available on this system.")
                continue
            root = tk.Tk()
            root.withdraw()
            try:
                clipboard_code = root.clipboard_get()
            except tk.TclError:
                root.destroy()
                print(">>> Clipboard is empty or unavailable.")
                continue
            root.destroy()
            inject_code_to_wow(clipboard_code)
            log_history("clipboard", clipboard_code[:80] + ("..." if len(clipboard_code) > 80 else ""))
            print(">>> Clipboard Injected to ForgeMaster Workbench!")

        elif choice == "3":
            convert_blp_to_png()

        elif choice == "4":
            query = input("Search query (leave blank for all): ")
            search_history(query)

        elif choice == "5":
            print("Goodbye!")
            break

        else:
            print(">>> Invalid option. Please choose 1-5.")

if __name__ == "__main__":
    main_menu()
