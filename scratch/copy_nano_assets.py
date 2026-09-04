import os
import shutil

brain_dir = r"C:\Users\omara\.gemini\antigravity\brain\7114a5d7-1dd5-4608-b762-373cf270a896"
target_dir = r"c:\Users\omara\Desktop\m proj\assets\images"

os.makedirs(target_dir, exist_ok=True)

# Find generated png files
png_files = [f for f in os.listdir(brain_dir) if f.endswith('.png')]
print("Found PNG files:", png_files)

mapping = {
    "boy": "nano_boy.png",
    "girl": "nano_girl.png",
    "responder": "nano_responder.png",
}

for fname in png_files:
    src = os.path.join(brain_dir, fname)
    if "boy" in fname:
        dst = os.path.join(target_dir, "nano_boy.png")
        shutil.copy2(src, dst)
        print("Copied boy to", dst)
    elif "girl" in fname:
        dst = os.path.join(target_dir, "nano_girl.png")
        shutil.copy2(src, dst)
        print("Copied girl to", dst)
    elif "responder" in fname:
        dst = os.path.join(target_dir, "nano_responder.png")
        shutil.copy2(src, dst)
        print("Copied responder to", dst)

