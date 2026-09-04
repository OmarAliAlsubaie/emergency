import os

file_path = r"c:\Users\omara\Desktop\m proj\lib\core\database\initial_seed_data.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Let's inspect where initialScenarios is located
marker = "static List<Scenario> get initialScenarios => ["
if marker in content:
    print("Found marker!")
else:
    print("Marker not found!")
