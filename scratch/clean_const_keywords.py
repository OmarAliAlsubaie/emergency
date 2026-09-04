file_path = r"c:\Users\omara\Desktop\m proj\lib\core\database\initial_seed_data.dart"

with open(file_path, "r", encoding="utf-8") as f:
    text = f.read()

# Replace any const Scenario( , const ScenarioStep( , const ScenarioOption(
text = text.replace("const Scenario(", "Scenario(")
text = text.replace("const ScenarioStep(", "ScenarioStep(")
text = text.replace("const ScenarioOption(", "ScenarioOption(")

with open(file_path, "w", encoding="utf-8") as f:
    f.write(text)

print("STRIPPED CONST FROM SCENARIOS SUCCESSFULLY!")
