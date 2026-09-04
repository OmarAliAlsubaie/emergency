import os

file_path = r"c:\Users\omara\Desktop\m proj\lib\core\database\initial_seed_data.dart"

with open(file_path, "r", encoding="utf-8") as f:
    content = f.read()

# Load python scripts code snippet
with open(r"c:\Users\omara\Desktop\m proj\scratch\generate_scenarios.py", "r", encoding="utf-8") as f1:
    code1 = f1.read().split('new_scenarios_code = """')[1].split('"""')[0]

with open(r"c:\Users\omara\Desktop\m proj\scratch\generate_all_scenarios.py", "r", encoding="utf-8") as f2:
    code2 = f2.read().split('scenarios_code = """')[1].split('"""')[0]

with open(r"c:\Users\omara\Desktop\m proj\scratch\build_full_scenarios.py", "r", encoding="utf-8") as f3:
    code3 = f3.read().split('scenarios_code = """')[1].split('"""')[0]

with open(r"c:\Users\omara\Desktop\m proj\scratch\build_all_categories.py", "r", encoding="utf-8") as f4:
    code4 = f4.read().split('code = """')[1].split('"""')[0]

all_new_scenarios = code1 + "\n" + code2 + "\n" + code3 + "\n" + code4

# Find where scenarios list ends or where knowledge articles start
marker = "static List<KnowledgeArticle> get knowledgeArticles => ["
if marker in content:
    parts = content.split(marker)
    # Insert new scenarios before the closing bracket of initialScenarios
    # The last line before marker is usually ];
    new_content = parts[0].rstrip()
    if new_content.endswith("];"):
        new_content = new_content[:-2] + all_new_scenarios + "\n      ];\n\n  " + marker + parts[1]
    else:
        new_content = parts[0] + all_new_scenarios + "\n  " + marker + parts[1]
    
    with open(file_path, "w", encoding="utf-8") as f_out:
        f_out.write(new_content)
    print("SUCCESSFULLY INJECTED 48 NEW SCENARIOS (72 TOTAL ACROSS ALL 8 CATEGORIES)!")
else:
    print("ERR: marker not found")
