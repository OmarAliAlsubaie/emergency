import re

file_path = r"c:\Users\omara\Desktop\m proj\lib\core\database\initial_seed_data.dart"

with open(file_path, "r", encoding="utf-8") as f:
    text = f.read()

# Replace parameter names
text = text.replace("isCorrect: true,", "isSafe: true,\n                  speedScore: 25,\n                  xpReward: 30,")
text = text.replace("isCorrect: false,", "isSafe: false,\n                  speedScore: 0,\n                  xpReward: 0,")
text = text.replace("safetyPoints:", "safetyScore:")
text = text.replace("consequenceAr:", "outcomeSummaryAr:")
text = text.replace("consequenceEn:", "outcomeSummaryEn:")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(text)

print("FIXED ScenarioOption SYNTAX SUCCESSFULLY!")
