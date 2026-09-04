file_path = r"c:\Users\omara\Desktop\m proj\lib\core\database\initial_seed_data.dart"

with open(file_path, "r", encoding="utf-8") as f:
    text = f.read()

target_str = """        ),
      ];

  // 6. Offline Knowledge Articles (Step-by-step Guides)
  
        // =========================================="""

replacement_str = """        ),

        // =========================================="""

text = text.replace(target_str, replacement_str)

with open(file_path, "w", encoding="utf-8") as f:
    f.write(text)

print("FIXED INITIAL_SCENARIOS CLOSURE PERFECTLY!")
