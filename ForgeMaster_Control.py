import os
import json
import subprocess
from datetime import datetime
from ForgeMaster_Injector import inject_code_to_wow

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

def main_menu():
    print("=== ForgeMaster Prime Desktop Control ===")
    print("1. Inject 'Fix_Taint.lua' to Workbench")
    print("2. Sync VS Code Clipboard to WoW")
    print("3. Convert last BLP to PNG")
    print("4. Search Previous Chat/Scan History")
    print("5. Exit")
    
    choice = input("Select Option: ")
    
    if choice == "2":
        # Get whatever is in your Windows/Mac clipboard and send it to WoW
        import tkinter as tk
        root = tk.Tk()
        root.withdraw()
        clipboard_code = root.clipboard_get()
        inject_code_to_wow(clipboard_code)
        log_history("clipboard", clipboard_code[:80] + ("..." if len(clipboard_code) > 80 else ""))
        print(">>> Clipboard Injected to ForgeMaster Workbench!")
    
    elif choice == "1":
        with open("Fix_Taint.lua", "r") as f:
            code = f.read()
            inject_code_to_wow(code)
            log_history("inject", "Fix_Taint.lua")

    elif choice == "4":
        query = input("Search query (leave blank for all): ")
        search_history(query)
            
if __name__ == "__main__":
    main_menu()
