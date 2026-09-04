file_path = r"c:\Users\omara\Desktop\m proj\lib\core\database\initial_seed_data.dart"

with open(file_path, "r", encoding="utf-8") as f:
    text = f.read()

# Let's count open vs close brackets
print("Open parens:", text.count("("), "Close parens:", text.count(")"))
print("Open brackets:", text.count("["), "Close brackets:", text.count("]"))
print("Open braces:", text.count("{"), "Close braces:", text.count("}"))
