import os

lib_dir = r"c:\Users\omara\Desktop\m proj\lib"

found = []
for root, dirs, files in os.walk(lib_dir):
    for file in files:
        if file.endswith(".dart"):
            fpath = os.path.join(root, file)
            with open(fpath, "r", encoding="utf-8") as f:
                content = f.read()
                if "SvgPicture" in content or ".svg" in content:
                    found.append(fpath)

print("Files referencing SvgPicture or .svg:")
for f in found:
    print("-", f)
