# TK: Recommended by Claude for git repository setup 
#
# Git LFS installieren falls nicht vorhanden
git lfs install

# LFS für große Dateien konfigurieren
git lfs track "*.png"
git lfs track "*.jpg"
git lfs track "*.ogg"
git lfs track "*.wav"
git lfs track "*.mp3"
git lfs track "*.fbx"
git lfs track "*.blend"

# .gitattributes committen
git add .gitattributes
git commit -m "Add LFS tracking"