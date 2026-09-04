file_path = r"c:\Users\omara\Desktop\m proj\lib\core\database\initial_seed_data.dart"

with open(file_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

depth = 0
for i, line in enumerate(lines):
    opens = line.count("[")
    closes = line.count("]")
    depth += (opens - closes)
    if depth < 0:
        print(f"Line {i+1}: Negative bracket depth ({depth}): {line.strip()}")
        break

print("Final bracket depth:", depth)
