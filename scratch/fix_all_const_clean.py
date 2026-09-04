file_path = r"c:\Users\omara\Desktop\m proj\lib\core\database\initial_seed_data.dart"

with open(file_path, "r", encoding="utf-8") as f:
    lines = f.readlines()

out_lines = []
in_initial_scenarios = False

for line in lines:
    if "static List<Scenario> get initialScenarios => [" in line:
        in_initial_scenarios = True
        out_lines.append(line)
        continue
    if in_initial_scenarios and "static List<KnowledgeArticle> get knowledgeArticles => [" in line:
        in_initial_scenarios = False
        out_lines.append(line)
        continue
    
    if in_initial_scenarios:
        # Replace 'const ' inside initialScenarios block
        clean_line = line.replace("const Scenario(", "Scenario(")
        clean_line = clean_line.replace("const ScenarioStep(", "ScenarioStep(")
        clean_line = clean_line.replace("const ScenarioOption(", "ScenarioOption(")
        clean_line = clean_line.replace("const [", "[")
        out_lines.append(clean_line)
    else:
        out_lines.append(line)

with open(file_path, "w", encoding="utf-8") as f:
    f.writelines(out_lines)

print("CLEANED CONST FROM INITIAL_SCENARIOS PERFECTLY!")
