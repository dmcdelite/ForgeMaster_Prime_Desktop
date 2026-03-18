import os
import subprocess
from ForgeMaster_Injector import inject_code_to_wow

def main_menu():
    print("=== ForgeMaster Prime Desktop Control ===")
    print("1. Inject 'Fix_Taint.lua' to Workbench")
    print("2. Sync VS Code Clipboard to WoW")
    print("3. Convert last BLP to PNG")
    print("4. Exit")
    
    choice = input("Select Option: ")
    
    if choice == "2":
        # Get whatever is in your Windows/Mac clipboard and send it to WoW
        import tkinter as tk
        root = tk.Tk()
        root.withdraw()
        clipboard_code = root.clipboard_get()
        inject_code_to_wow(clipboard_code)
        print(">>> Clipboard Injected to ForgeMaster Workbench!")
    
    elif choice == "1":
        with open("Fix_Taint.lua", "r") as f:
            inject_code_to_wow(f.read())
            
if __name__ == "__main__":
    main_menu()
