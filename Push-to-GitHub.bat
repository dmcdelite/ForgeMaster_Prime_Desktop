@echo off
git init
git remote add origin https://github.com/dmcdelite/ForgeMaster_Prime_Desktop.git
git branch -M main
git add .
git commit -m "ForgeMaster Prime: Manual File Generation"
git push -u origin main --force
pause